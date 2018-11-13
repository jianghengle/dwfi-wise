<template>
  <div class="modal" :class="{'is-active': opened}">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Import data from a csv file</p>
        <button class="delete" @click="close"></button>
      </header>
      <section class="modal-card-body">
        <div v-if="error" class="notification is-danger login-text">
          <button class="delete" @click="error=''"></button>
          {{error}}
        </div>

        <div class="my-section">
          <p>The first line of the csv file is the header, which is the column names seperated by commas.</p>
          <p>The columns to be retreived are <span v-for="(c,i) in allColumns"><span v-if="i!=0">, </span><strong >{{c}}</strong></span>. The order does not matter.</p>
          <p>The integer data cell is like <strong>1</strong>; the text data cell is like <strong>"Say \"Hi\""</strong>(Please note string is surrounded by <strong>"</strong> and the <strong>"</strong> inside is using <strong>\"</strong>); the empty cells need to be filled by <strong>null</strong></p>
          <p v-for="n in notes"><span v-html="n"></span></p>
        </div>

        <div class="my-section" v-if="opened">
          <div class="file">
            <label class="file-label">
              <input class="file-input" type="file" name="resume" @change="onFileChange">
              <span class="file-cta">
                <span class="file-icon">
                  <icon name="upload"></icon>
                </span>
                <span class="file-label">
                  {{file ? file.name : 'Choose a file…'}}
                </span>
              </span>
            </label>
          </div>
        </div>

        <div class="my-section" v-if="file">
          <p v-if="!deletedHeaders.length">No data column found.</p>
          <p v-else>Found columns: <span v-for="(h,i) in deletedHeaders"><span v-if="i!=0">, </span><strong>{{h}}</strong></span></p>
          <p v-if="!rows.length">No data rows found</p>
          <p v-else>Found data rows: {{rows.length}}</p>
        </div>

        <div class="my-section" v-if="file && waiting">
          <progress class="progress is-link" :value="results.length" :max="rows.length"></progress>
        </div>

        <div class="my-section" v-if="rows.length && results.length == rows.length">
          Done import: {{successes}} succeed, {{failures}} failed. 
        </div>

      </section>
      <footer class="modal-card-foot">
        <a class="button is-link" :disabled="!canImport" :class="{'is-loading': waiting}" @click="importData">Import</a>
        <a class="button" @click="close">Cancel</a>
      </footer>
    </div>
  </div>
</template>

<script>
export default {
  name: 'import-modal',
  data () {
    return {
      waiting: false,
      error: '',
      file: null,
      header: {},
      rows: [],
      results: [],
    }
  },
  computed: {
    opened () {
      return this.$store.state.modals.importModal.opened
    },
    tableName () {
      return this.$route.params.tableName
    },
    importOption () {
      if(this.tableName)
        return this.$store.state.table.tables[this.tableName].importOption
      return {columns: [], relations: {}}
    },
    columns () {
      return this.importOption.columns
    },
    relations () {
      return this.importOption.relations
    },
    allColumns () {
      return this.columns.concat(Object.keys(this.relations))
    },
    notes () {
      return this.importOption.notes
    },
    deletedHeaders () {
      return Object.keys(this.header)
    },
    canImport () {
      return this.file && this.deletedHeaders.length && this.rows.length && this.results.length < this.rows.length
    },
    url () {
      return this.importOption.url
    },
    successes () {
      return this.results.filter(function(r){
        return r
      }).length
    },
    failures () {
      return this.rows.length - this.successes
    }
  },
  watch: {
    opened: function (val) {
      this.waiting = false
      this.error = ''
      this.file = null
      this.header = {}
      this.rows = []
      this.results = []
    },
  },
  methods: {
    close(result){
      if(result){
        var callback = this.$store.state.modals.importModal.callback
        if(callback){
          var method = callback.method
          var context = callback.context
          var args = callback.args
          method.apply(context, args)
        }
      }
      this.$store.commit('modals/closeImportModal')
    },
    onFileChange(e) {
      var files = e.target.files || e.dataTransfer.files
      if (!files.length)
        return
      this.file = files[0]

      var vm = this
      var reader = new FileReader()
      reader.onload = function(e) {
        var text = reader.result
        var lines = text.split('\n')
        if(lines.length == 0) {
          vm.header = {}
          vm.rows = []
          return 
        }
        vm.getHeader(lines[0])
        vm.rows = lines.slice(1).filter(function(l){
          return l.trim()
        })
      }
      reader.readAsText(this.file)
    },
    getHeader (line) {
      var header = {}
      var cols = line.split(',')
      for(var i=0;i<cols.length;i++){
        var col = cols[i].trim()
        if(this.allColumns.includes(col)){
          header[col] = i
        }
      }
      this.header = header
    },
    importData () {
      if(!this.canImport)
        return
      if(this.waiting)
        return
      var vm = this
      var promises = []
      this.rows.forEach(function(row){
        var data = null
        try {
          data = JSON.parse('[' + row + ']')
        }
        catch(err) {
          vm.results.push(false)
          return
        }
        var message = vm.buildMessage(data)
        var promise = vm.$http.post(xHTTPx + vm.url, message).then(response => {
          vm.results.push(true)
        }, response => {
          vm.error = 'Some import failed'
          vm.results.push(false)
        })
        promises.push(promise)
      })
      vm.waiting = true
      Promise.all(promises).then((response) => {
        vm.importDone()
      }, (response) => {
        vm.importDone()
      })
    },
    buildMessage(data) {
      var vm = this
      var message = {}
      if(this.tableName != 'files'){
        vm.columns.forEach(function(col){
          var val = null
          if(vm.header[col] !== undefined){
            val = data[vm.header[col]]
            if(col == 'startDate' || col == 'endDate'){
              if(val){
                val = Date.parse(val + ' 00:00:00 CST')
                val = Math.floor(val / 1000)
              }
            }
          }
          message[col] = val
        })
        Object.keys(vm.relations).forEach(function(col){
          var rel = vm.relations[col]
          var val = []
          if(vm.header[col] !== undefined){
            var str = data[vm.header[col]]
            if(str){
              val = str.split(',').map(function(s){
                var obj = {}
                obj[rel[0]] = parseInt(s)
                obj[rel[1]] = ''
                return obj
              })
            }
          }
          message[col] = JSON.stringify(val)
        })
      }else{
        var formData = new FormData()
        formData.append('uploadFile', 'No')
        vm.columns.forEach(function(col){
          var val = ''
          if(vm.header[col] !== undefined){
            val = data[vm.header[col]]
          }
          formData.append(col, val)
        })
        message = formData
      }
      return message
    },
    importDone () {
      this.waiting = false
      this.$nextTick(function(){
        if(this.successes == this.rows.length){
          this.close(true)
        }
      })
    }
  },
}
</script>

<style lang="scss" scoped>
.my-section {
  margin-bottom: 20px;
}
</style>
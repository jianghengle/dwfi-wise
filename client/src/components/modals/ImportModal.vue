<template>
  <div class="modal" :class="{'is-active': opened}">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Import data from a Tab delimited file</p>
        <button class="delete" @click="close"></button>
      </header>
      <section class="modal-card-body">
        <div v-if="error" class="notification is-danger login-text">
          <button class="delete" @click="error=''"></button>
          {{error}}
        </div>

        <div class="my-section">
          <p>The first line of the file is the header: <span v-for="(c,i) in allColumns"><span v-if="i!=0">, </span><strong >{{c}}</strong></span>.</p>
          <p>Your file could have more or less columns than the columns above.</p>
          <p>You could simply leave any data cell empty if it is not appliable.</p>
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
          <p v-if="!detectedHeaders.length">No data column found.</p>
          <p v-else>Found columns: <span v-for="(h,i) in detectedHeaders"><span v-if="i!=0">, </span><strong>{{h}}</strong></span></p>
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
    detectedHeaders () {
      return Object.keys(this.header)
    },
    canImport () {
      return this.file && this.detectedHeaders.length && this.rows.length && this.results.length < this.rows.length
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
        var lines = text.split('\r\n')
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
      var cols = line.split('\t')
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
        var data = vm.parseDateRow(row)
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
    parseDateRow (row) {
      var data = []
      row.split('\t').forEach(function(cell){
        var c = cell.trim()
        if(c.startsWith('"') && c.endsWith('"')){
          c = c.slice(1,-1)
        }
        if(!c || c == 'null' || c == 'na' || c == 'N/A'){
          c = null
        }
        data.push(c)
      })
      return data
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
            }else if(col == 'programId' || col == 'pointOfContact' || col == 'peopleId'){
              if(val){
                val = parseInt(val)
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
              val = vm.parseRelations(str, col, rel)
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
    parseRelations (str, col, rel) {
      var val = []
      if(col == 'workPlans'){
        var workPlan = {}
        str.split('\n').forEach(function(s){
          s = s.trim()
          var year = parseInt(s)
          if(workPlan.year){
            if(year >= 2015){
              val.push(workPlan)
              workPlan = {year: year}
            }else{
              if(workPlan.plan){
                workPlan.plan = workPlan.plan + '\n' + s
              }else{
                workPlan.plan = s
              }
            }
          }else{
            if(year >= 2015){
              workPlan.year = year
            }
          }
        })
      }else{
        str.split('\n').forEach(function(s){
          s = s.trim()
          if(s){
            var obj = {}
            obj[rel[0]] = parseInt(s)

            var first = s.indexOf(',')
            var last = s.lastIndexOf(',')
            if(first == -1){
              obj[rel[1]] = ''
            }else if(first == last){
              obj[rel[1]] = s.slice(first + 1).trim()
            }else{
              obj[rel[1]] = s.slice(first + 1, last).trim()
            }
            val.push(obj)
          }
        })
      }
      return val
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
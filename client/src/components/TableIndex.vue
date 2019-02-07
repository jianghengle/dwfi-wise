<template>
  <div>
    <div class="is-size-4 has-text-weight-bold">
      {{tableLabel}}
    </div>
    <div class="has-text-centered" v-if="waiting">
      <icon name="spinner" class="icon is-medium fa-spin"></icon>
    </div>
    <div v-else>
      <div class="columns no-margin-bottom">
        <div class="column">
          <div class="field is-grouped">
            <p class="control">
              <a class="button is-white">
                {{processedItems.length}} of total {{items.length}} items
              </a>
            </p>
            <p class="control" v-if="privileges == 'Edit' || privileges == 'Approve'">
              <router-link class="button" :to="'/new/' + tableName">
                <icon name="plus"></icon>&nbsp;New
              </router-link>
            </p>
            <p class="control" v-if="privileges == 'Edit' || privileges == 'Approve'">
              <a class="button" @click="openImportModal">
                <icon name="upload"></icon>&nbsp;Import
              </a>
            </p>
            <p class="control" v-if="selected.length">
              <a class="button" @click="exportSelected">
                <icon name="download"></icon>&nbsp;Export ({{selected.length}})
              </a>
            </p>
            <p class="control" v-if="(privileges == 'Edit' || privileges == 'Approve') && selected.length">
              <a class="button is-danger" @click="deleteSelected">
                <icon name="remove"></icon>&nbsp;Delete ({{selected.length}})
              </a>
            </p>
          </div>
        </div>
        <div class="column">
          <div class="field">
            <p class="control has-icons-left">
              <input class="input" type="text" v-model="searchInput">
              <span class="icon is-small is-left">
                <icon name="search"></icon>
              </span>
            </p>
          </div>
        </div>
      </div>

      <div>
        <table class="table is-fullwidth is-hoverable is-striped">
          <thead>
            <tr>
              <th>
                <label class="checkbox" @click="toggleSelectAll">
                  <input type="checkbox" v-model="selectAll">
                </label>
              </th>
              <th v-for="(col, i) in columns" @click="sortItems(i)" class="clickable">
                {{col.label}}
                <span v-if="sortOption.index==i">
                  <icon name="sort-asc" v-if="sortOption.asc"></icon>
                  <icon name="sort-desc" v-if="!sortOption.asc"></icon>
                </span>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, i) in processedItems" @click="showItem(item)" class="clickable">
              <td @click.stop="">
                <label class="checkbox">
                  <input type="checkbox" v-model="selection[item.id]">
                </label>
              </td>
              <td v-for="col in columns">
                {{item[col.name]}}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import DateForm from 'dateformat'

export default {
  name: 'table-index',
  data () {
    return {
      items: [],
      waiting: false,
      error: '',
      searchInput: '',
      selection: {},
      selectAll: false,
      relations: {}
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
    privileges () {
      return this.$store.state.user.privileges
    },
    tableName () {
      return this.$route.params.tableName
    },
    tableOption () {
      var tableOption = this.$store.state.table.tables[this.tableName]
      return tableOption ? tableOption : {}
    },
    tableLabel () {
      return this.tableOption.label
    },
    columns () {
      return this.tableOption.columns
    },
    sortOption () {
      return this.tableOption.sort
    },
    searchText () {
      return this.tableOption.search
    },
    deleteOption () {
      return this.tableOption.deleteOption
    },
    processedItems () {
      var vm = this
      this.items.sort(this.compareItems)
      
      var items = this.items.map(function(item){
        var obj = {}
        vm.columns.forEach(function(column){
          if(column.type == 'time' && item[column.name]){
            obj[column.name] = DateForm(item[column.name]*1000, 'mmm dd yyyy')
          }else{
            obj[column.name] = item[column.name]
          }
        })
        return obj
      })
      return items.filter(function(item){
        var values = Object.values(item)
        for(var i=0;i<values.length;i++){
          var value = values[i]
          if(value != null && value.toString().toLowerCase().indexOf(vm.searchText) != -1){
            return true
          }
        }
      })
    },
    selected () {
      var vm = this
      return Object.keys(vm.selection).filter(function(k){
        return vm.selection[k]
      })
    },
    itemMap () {
      var map = {}
      for(var i=0;i<this.items.length;i++){
        map[this.items[i].id] = this.items[i]
      }
      return map
    },
    selectedItems () {
      var vm = this
      return vm.selected.map(function(id){
        return vm.itemMap[id]
      })
    },
    exportOption () {
      return this.tableOption.exportOption
    }
  },
  watch: {
    tableName: function (val) {
      this.selection = {}
      this.selectAll = false
      this.getItems()
      this.searchInput = this.searchText
    },
    searchInput: function (val) {
      if(val != this.searchText){
        this.$store.commit('table/setSearch', {table: this.tableName, search: val})
      }
    }
  },
  methods: {
    getItems () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_' + this.tableName).then(response => {
        this.items = response.body
        var selection = {}
        this.items.forEach(function(i){
          selection[i.id] = false
        })
        this.selection = selection
        this.waiting = false
        this.error = ''
      }, response => {
        this.error = 'Failed to get file!'
        this.waiting = false
      })
    },
    compareItems (a, b) {
      var sortColumn = this.columns[this.sortOption.index]
      var v1 = a[sortColumn.name]
      var v2 = b[sortColumn.name]
      if(v1 == null && v2 == null)
        return 0
      if(v1 == null && v2 != null)
        return this.sortOption.asc ? -1 : 1
      if(v1 != null && v2 == null)
        return this.sortOption.asc ? 1 : -1
      if(sortColumn.type == 'str'){
        v1 = v1.toString()
        v2 = v2.toString()
        return this.sortOption.asc ? v1.localeCompare(v2) : v2.localeCompare(v1)
      }
      return this.sortOption.asc ? (v1 - v2) : (v2 - v1)
    },
    sortItems (index) {
      this.$store.commit('table/setSort', {table: this.tableName, sort: index})
    },
    showItem (item) {
      this.$router.push('/' + this.tableName + '/' + item.id)
    },
    openImportModal () {
      var callback = {
        context: this,
        method: this.getItems,
        args: []
      }
      this.$store.commit('modals/openImportModal', callback)
    },
    toggleSelectAll () {
      this.$nextTick(function(){
        var selection = {}
        var selectAll = this.selectAll
        this.items.forEach(function(i){
          selection[i.id] = false
        })
        this.processedItems.forEach(function(i){
          selection[i.id] = selectAll
        })
        this.selection = selection
      })
    },
    deleteSelected () {
      var confirm = {
        title: 'Delete Selected',
        message: 'Are you sure to delete the selected ' + this.selected.length + ' item(s)?',
        button: 'Yes, I am sure.',
        callback: {
          context: this,
          method: this.deleteSelectedConfirmed,
          args: []
        }
      }
      this.$store.commit('modals/openConfirmModal', confirm)
    },
    deleteSelectedConfirmed () {
      var url = this.deleteOption.url
      var vm = this
      var promises = []
      this.selected.forEach(function(id){
        var message = {}
        message[vm.deleteOption.id] = id
        var promise = vm.$http.post(xHTTPx + url, message).then(response => {
        }, response => {
          vm.error = 'Some delete failed'
        })
        promises.push(promise)
      })
      vm.waiting = true
      Promise.all(promises).then((response) => {
        vm.getItems()
      }, (response) => {
        vm.getItems()
      })
    },
    exportSelected () {
      var vm = this
      var promises = []
      Object.keys(vm.exportOption.relations).forEach(function(k){
        vm.relations[k] = []
        var rel = vm.exportOption.relations[k]
        var ids = []
        vm.selectedItems.forEach(function(item){
          if(item[rel[0]]){
            ids.push(item[rel[0]])
          }
        })
        if(ids.length){
          let message = {'table': vm.tableName, 'ids': JSON.stringify(ids)}
          var promise = vm.$http.post(xHTTPx + rel[1], message).then(response => {
            vm.relations[k] = response.body
          }, response => {
            vm.error = 'Some export failed'
          })
          promises.push(promise)
        }
      })

      if(promises.length){
        Promise.all(promises).then((response) => {
          vm.exportNow()
        }, (response) => {
          vm.exportNow()
        })
      }else{
        vm.exportNow()
      }
    },
    exportNow () {
      var columns = this.exportOption.columns
      var relations = this.exportOption.relations
      var rows = [columns.join('\t')]
      var vm = this
      vm.selectedItems.forEach(function(item){
        var row = []
        columns.forEach(function(col){
          var cell = item[col]
          if(relations[col]){
            var rs = vm.getItemRelations(item, col)
            if(rs.length){
              cell = rs.join('\n')
            }
          }
          if(cell){
            if(col == 'startDate' || col == 'endDate'){
              cell = DateForm(cell*1000, 'mmm dd yyyy')
            }else{
              cell = cell.toString()
            }
          }else{
            cell = ''
          }
          row.push(cell)
        })
        rows.push(row.join('\t'))
      })
      var str = rows.join('\r\n')
      var blob = new Blob([str], {type: 'file'})
      var uri = URL.createObjectURL(blob)

      var link = document.createElement("a");
      link.download = 'data.txt';
      link.href = uri;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    },
    getItemRelations (item, col) {
      var rel = this.exportOption.relations[col]
      var id = item[rel[0]]
      var arr = this.relations[col]
      var ret = []
      arr.forEach(function(i){
        if(i[0] == id){
          ret.push(i[1])
        }
      })
      return ret
    }
  },
  mounted () {
    this.getItems()
    this.searchInput = this.searchText
  }
}
</script>

<style lang="scss" scoped>

.no-margin-bottom {
  margin-bottom: 0px;
}

.clickable {
  cursor: pointer;
}

</style>

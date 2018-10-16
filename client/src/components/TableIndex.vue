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
            <p class="control">
              <router-link class="button" :to="'/new/' + tableName">
                <icon name="plus"></icon>&nbsp;New
              </router-link>
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
      searchInput: ''
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
    tableName () {
      return this.$route.params.tableName
    },
    tableOption () {
      return this.$store.state.table.tables[this.tableName]
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
    }
  },
  watch: {
    tableName: function (val) {
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
      if(sortColumn.type == 'str')
        return this.sortOption.asc ? v1.localeCompare(v2) : v2.localeCompare(v1)
      return this.sortOption.asc ? (v1 - v2) : (v2 - v1)
    },
    sortItems (index) {
      this.$store.commit('table/setSort', {table: this.tableName, sort: index})
    },
    showItem (item) {
      this.$router.push('/' + this.tableName + '/' + item.id)
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

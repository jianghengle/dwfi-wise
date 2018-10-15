import Vue from 'vue'
import Vuex from 'vuex'
import user from './modules/user'
import table from './modules/table'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    user: user,
    table: table
  }
})

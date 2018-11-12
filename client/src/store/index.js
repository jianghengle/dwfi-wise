import Vue from 'vue'
import Vuex from 'vuex'
import user from './modules/user'
import table from './modules/table'
import modals from './modules/modals'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    user: user,
    table: table,
    modals: modals
  }
})

// initial state
export const state = {
  email: localStorage.getItem('email'),
  token: localStorage.getItem('token'),
  privileges: localStorage.getItem('privileges')
}

// mutations
export const mutations = {

  setEmail (state, email) {
    state.email = email
  },

  setToken (state, token) {
    state.token = token
  },

  setPrivileges (state, privileges) {
    state.privileges = privileges
  },

  reset (state) {
    state.email = null
    state.token = null
    state.privileges = null
    localStorage.removeItem('email')
    localStorage.removeItem('token')
    localStorage.removeItem('privileges')
  }
}

export default {
  namespaced: true,
  state,
  mutations
}

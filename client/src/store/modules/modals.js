// initial state
export const state = {
  confirmModal: {
    opened: false,
    title: '',
    message: '',
    button: '',
    callback: null
  },
  importModal: {
    opened: false,
    callback: null
  },
}

// mutations
export const mutations = {

  openConfirmModal (state, confirm) {
    state.confirmModal.opened = true
    state.confirmModal.title = confirm.title
    state.confirmModal.message = confirm.message
    state.confirmModal.button = confirm.button
    state.confirmModal.callback = confirm.callback
  },

  closeConfirmModal (state) {
    state.confirmModal.opened = false
    state.confirmModal.title = ''
    state.confirmModal.message = ''
    state.confirmModal.button = ''
    state.confirmModal.callback = null
  },

  openImportModal (state, callback) {
    state.importModal.callback = callback
    state.importModal.opened = true
  },

  closeImportModal (state) {
    state.importModal.opened = false
    state.importModal.callback = null
  },
}

export default {
  namespaced: true,
  state,
  mutations
}

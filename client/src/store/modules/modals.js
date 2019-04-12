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
  newGrantModal: {
    opened: false,
    source: null,
    key: null,
    callback: null
  },
  newPublicationModal: {
    opened: false,
    source: null,
    key: null,
    callback: null
  },
  newFileModal: {
    opened: false,
    source: null,
    key: null,
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

  openNewGrantModal (state, context) {
    state.newGrantModal.source = context.source
    state.newGrantModal.key = context.key
    state.newGrantModal.callback = context.callback
    state.newGrantModal.opened = true
  },

  closeNewGrantModal (state) {
    state.newGrantModal.opened = false
    state.newGrantModal.source = null
    state.newGrantModal.key = null
    state.newGrantModal.callback = null
  },

  openNewPublicationModal (state, context) {
    state.newPublicationModal.source = context.source
    state.newPublicationModal.key = context.key
    state.newPublicationModal.callback = context.callback
    state.newPublicationModal.opened = true
  },

  closeNewPublicationModal (state) {
    state.newPublicationModal.opened = false
    state.newPublicationModal.source = null
    state.newPublicationModal.key = null
    state.newPublicationModal.callback = null
  },

  openNewFileModal (state, context) {
    state.newFileModal.source = context.source
    state.newFileModal.key = context.key
    state.newFileModal.callback = context.callback
    state.newFileModal.opened = true
  },

  closeNewFileModal (state) {
    state.newFileModal.opened = false
    state.newFileModal.source = null
    state.newFileModal.key = null
    state.newFileModal.callback = null
  },
}

export default {
  namespaced: true,
  state,
  mutations
}

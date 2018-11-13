<template>
  <div id="app">
    <my-header></my-header>
    <div class="container main-window">
      <router-view></router-view>
    </div>
    <confirm-modal></confirm-modal>
    <import-modal></import-modal>
  </div>
</template>

<script>
import Vue from 'vue'
import MyHeader from './components/MyHeader'
import ConfirmModal from './components/modals/ConfirmModal'
import ImportModal from './components/modals/ImportModal'

export default {
  name: 'app',
  components: {
    MyHeader,
    ConfirmModal,
    ImportModal
  }
}
</script>

<style lang="scss">
@import "~bulma";

.main-window {
  padding: 10px;
}

.date-picker-wrapper {
  display: inline-block;
}

.date-picker-input{
  cursor: pointer;
  height: 35px;
  width: 120px;
  text-align: center;
  font-size: 1rem;
}

.back-button {
  position: relative;
  top: -5px;
}
</style>

<template>
  <div id="app">
    <my-header></my-header>
    <div class="container main-window">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import MyHeader from './components/MyHeader'

export default {
  name: 'app',
  components: {
    MyHeader
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

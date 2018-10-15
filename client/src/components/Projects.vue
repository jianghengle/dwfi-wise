<template>
  <div>
    projects
  </div>
</template>

<script>

export default {
  name: 'projects',
  computed: {
    token () {
      return this.$store.state.user.token
    }
  },
  methods: {
    login () {
    }
  },
  mounted () {
    
  }
}
</script>

<style lang="scss" scoped>


</style>

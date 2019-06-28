<template>
  <div>
    <h4 class="title is-4">
      New Impact
    </h4>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Impact Indicator</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <textarea id="textarea-description" class="textarea" v-model="impactIndicator" @change="descriptionChanged"></textarea>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Number</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="number" v-model.number="numberField">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label">
        <!-- Left empty for spacing -->
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button is-link" @click="create">Create</button>
          </div>
          <div class="control">
            <router-link class="button is-text" :to="'/table/impacts'">Cancel</router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import DateForm from 'dateformat'

export default {
  name: 'new-impact',
  data () {
    return {
      waiting: false,
      error: '',
      impactIndicator: '',
      numberField: null
    }
  },
  methods: {
    create () {
      var message = {
        impactIndicator: this.impactIndicator,
        numberField: this.numberField
      }
      this.$http.post(xHTTPx + '/create_impact', message).then(response => {
        var resp = response.body
        this.waiting = false
        this.error = ''
        this.$router.push('/table/impacts')
      }, response => {
        this.error = 'Failed to create impact!'
        this.waiting = false
      })
    },
    descriptionChanged () {
      var el = document.getElementById('textarea-description');
      el.style.height = "1px";
      el.style.height = (25+el.scrollHeight)+"px";
    }
  }
}
</script>

<style lang="scss" scoped>
.item-row {
  margin-bottom: 8px;
}
</style>

<template>
  <div>
    <h4 class="title is-4">
      <a class="button back-button" @click="$router.go(-1)">
        <icon name="chevron-left"></icon>
      </a>&nbsp;&nbsp;&nbsp;&nbsp;
      Impact {{impactId}}
    </h4>

    <div class="has-text-centered" v-if="waiting">
      <icon name="spinner" class="icon is-medium fa-spin"></icon>
    </div>

    <div v-if="error" class="notification is-danger">
      <button class="delete" @click="error=''"></button>
      {{error}}
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Impact Indicator</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <textarea id="textarea-description" class="textarea" v-model="impactIndicator" @change="descriptionChanged" :disabled="privileges == 'Read Only'"></textarea>
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
            <input class="input" type="number" v-model.number="numberField" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="privileges == 'Edit' || privileges == 'Approve'">
      <div class="field-label">
        <!-- Left empty for spacing -->
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button is-link" @click="update" :disabled="!changed" :class="{'is-loading': waiting}">Update</button>
          </div>
          <div class="control">
            <button class="button is-danger" @click="deleteSelf" :disabled="changed" :class="{'is-loading': waiting}">Delete</button>
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

export default {
  name: 'impact',
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      oldImpact: null,
      impactIndicator: '',
      numberField: ''
    }
  },
  computed: {
    privileges () {
      return this.$store.state.user.privileges
    },
    impactId () {
      return this.$route.params.id
    },
    changed () {
      var impact = this.collectImpact()
      if(JSON.stringify(impact) != JSON.stringify(this.oldImpact))
        return true
      return false
    }
  },
  methods: {
    collectImpact () {
      return {
        impactIndicator: this.impactIndicator,
        numberField: this.numberField
      }
    },
    getImpact () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_impact/' + this.impactId).then(response => {
        var resp = response.body
        this.impactIndicator = resp.impactIndicator
        this.numberField = resp.numberField
        this.oldImpact = this.collectImpact()
        this.waiting = false
        this.error = ''
        this.$nextTick(() => {
          this.descriptionChanged()
        })
      }, response => {
        this.error = 'Failed to get impact!'
        this.waiting = false
      })
    },
    update () {
      var message = {
        impactIndicator: this.impactIndicator,
        numberField: this.numberField
      }
      this.$http.post(xHTTPx + '/update_impact/' + this.impactId, message).then(response => {
        var resp = response.body
        this.success = 'Data updated successfully!'
        this.getImpact()
      }, response => {
        this.error = 'Failed to update impact!'
        this.waiting = false
      })
    },
    deleteSelf () {
      var confirm = {
        title: 'Delete Impact',
        message: 'Are you sure to delete the impact?',
        button: 'Yes, delete it.',
        callback: {
          context: this,
          method: this.deleteConfirmed,
          args: []
        }
      }
      this.$store.commit('modals/openConfirmModal', confirm)
    },
    deleteConfirmed () {
      var message = {impactId: this.impactId}
      this.$http.post(xHTTPx + '/delete_impact', message).then(response => {
        if(response.body.ok){
          this.$router.replace('/table/impacts')
        }
      }, response => {
        this.error = 'Failed to delete impact!'
        this.waiting = false
      })
    },
    descriptionChanged () {
      var el = document.getElementById('textarea-description');
      el.style.height = "1px";
      el.style.height = (25+el.scrollHeight)+"px";
    }
  },
  mounted () {
    this.getImpact()
  }
}
</script>

<style lang="scss" scoped>
.item-row {
  margin-bottom: 8px;
}
</style>

<template>
  <div>
    <h4 class="title is-4">
      New Faculty
    </h4>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">People</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="select">
              <select v-model="peopleId">
                <option v-for="opt in allPeople" v-bind:value="opt.id">{{opt.label}}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Year Joined</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="select">
              <select v-model="yearJoined">
                <option v-for="opt in yearOptions">{{opt}}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Status</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="select">
              <select v-model="status">
                <option>New</option>
                <option>Returning</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Campus</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="select">
              <select v-model="campus">
                <option>UNL</option>
                <option>UNO</option>
                <option>UNK</option>
                <option>UNMC</option>
                <option>Other</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Department</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="department">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Area of Expertise</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <textarea id="textarea-expertise" class="textarea" v-model="areaOfExpertise" @change="textareaChanged('textarea-expertise')"></textarea>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Expertise Title</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="expertiseTitle">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label">
        <label class="label">Work Plans</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addWorkPlan"><icon name="plus"></icon>&nbsp;Work Plan</button>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(w, i) in workPlans">
      <div class="field-label is-normal">
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="w.year">
              <option v-for="opt in yearOptions">{{opt}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <textarea :id="'textarea-work-plan-' + i" class="textarea" v-model="w.plan" @change="textareaChanged('textarea-work-plan-' + i)"></textarea>
          </p>
          <p class="control">
            <a class="button is-text" @click="removeWorkPlan(i)">
              <icon name="remove"></icon>
            </a>
          </p>
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
            <button class="button is-link" @click="create" :disabled="!peopleId">Create</button>
          </div>
          <div class="control">
            <router-link class="button is-text" :to="'/table/people'">Cancel</router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import DateForm from 'dateformat'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'new-program',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
      allPeople: [],
      peopleId: null,
      thisYear: null,
      yearOptions: [],
      yearJoined: null,
      status: 'New',
      campus: 'UNL',
      department: '',
      areaOfExpertise: '',
      expertiseTitle: '',
      workPlans: []
    }
  },
  methods: {
    requestResources () {
      this.$http.get(xHTTPx + '/get_people').then(response => {
        this.allPeople = response.body.map(function(p){
          return {id: p.id, label: p.firstName + ' ' + p.lastName + ' [' + p.id + ']'}
        })
      })
    },
    addWorkPlan () {
      this.workPlans.unshift({year: this.thisYear, plan: ''})
    },
    removeWorkPlan (idx) {
      this.workPlans.splice(idx, 1)
    },
    create () {
      var message = {
        peopleId: this.peopleId,
        yearJoined: this.yearJoined,
        status: this.status,
        campus: this.campus,
        department: this.department,
        areaOfExpertise: this.areaOfExpertise,
        expertiseTitle: this.expertiseTitle,
        workPlans: JSON.stringify(this.workPlans)
      }
      this.$http.post(xHTTPx + '/create_faculty', message).then(response => {
        var resp = response.body
        this.waiting = false
        this.error = ''
        this.$router.push('/table/faculty')
      }, response => {
        this.error = 'Failed to create faculty!'
        this.waiting = false
      })
    },
    textareaChanged (id) {
      var el = document.getElementById(id);
      el.style.height = "1px";
      el.style.height = (25+el.scrollHeight)+"px";
    }
  },
  mounted () {
    this.requestResources()
    var d = new Date()
    this.thisYear = d.getFullYear()
    this.yearJoined = this.thisYear
    for(var i=2015;i<=this.thisYear+5;i++){
      this.yearOptions.push(i)
    }
  }
}
</script>

<style lang="scss" scoped>

</style>

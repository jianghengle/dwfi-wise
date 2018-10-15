import Vue from 'vue'
import Router from 'vue-router'
import SignIn from '@/components/SignIn'
import TableIndex from '@/components/TableIndex'
import Program from '@/components/Program'
import NewProgram from '@/components/NewProgram'


Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      redirect: '/sign_in'
    },
    {
      path: '/sign_in',
      name: 'SignIn',
      component: SignIn
    },
    {
      path: '/table/:tableName',
      name: 'TableIndex',
      component: TableIndex
    },
    {
      path: '/new/programs',
      name: 'NewProgram',
      component: NewProgram
    },
    {
      path: '/programs/:id',
      name: 'Program',
      component: Program
    },
  ]
})

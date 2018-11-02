var tables = {
  programs: {
    label: 'Programs',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'title', type: 'str', label: 'Title'},
      {name: 'status', type: 'str', label: 'Status'},
      {name: 'startDate', type: 'time', label: 'Start Date'},
      {name: 'endDate', type: 'time', label: 'End Date'},
      {name: 'country', type: 'str', label: 'Country'},
      {name: 'isPublished', type: 'str', label: 'Is Published'}
    ],
    sort: {index: 0, asc: false},
    search: ''
  },
  projects: {
    label: 'Projects',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'title', type: 'str', label: 'Title'},
      {name: 'status', type: 'str', label: 'Status'},
      {name: 'startDate', type: 'time', label: 'Start Date'},
      {name: 'endDate', type: 'time', label: 'End Date'},
      {name: 'country', type: 'str', label: 'Country'},
      {name: 'programId', type: 'int', label: 'Program Id'},
      {name: 'isPublished', type: 'str', label: 'Is Published'}
    ],
    sort: {index: 0, asc: false},
    search: ''
  },
  events: {
    label: 'Events',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'title', type: 'str', label: 'Title'},
      {name: 'status', type: 'str', label: 'Status'},
      {name: 'startDate', type: 'time', label: 'Start Date'},
      {name: 'endDate', type: 'time', label: 'End Date'},
      {name: 'country', type: 'str', label: 'Country'},
      {name: 'isPublished', type: 'str', label: 'Is Published'}
    ],
    sort: {index: 0, asc: false},
    search: ''
  },
  visiting_scholars: {
    label: 'Scholars',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'firstName', type: 'str', label: 'First Name'},
      {name: 'lastName', type: 'str', label: 'Last Name'},
      {name: 'status', type: 'str', label: 'Status'},
      {name: 'startDate', type: 'time', label: 'Start Date'},
      {name: 'endDate', type: 'time', label: 'End Date'},
      {name: 'country', type: 'str', label: 'Country'},
      {name: 'isPublished', type: 'str', label: 'Is Published'}
    ],
    sort: {index: 0, asc: false},
    search: ''
  },
  people: {
    label: 'People',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'firstName', type: 'str', label: 'First Name'},
      {name: 'lastName', type: 'str', label: 'Last Name'},
      {name: 'title', type: 'str', label: 'Title'},
      {name: 'dwfiAffiliation', type: 'str', label: 'DWFI Affiliation'}
    ],
    sort: {index: 0, asc: false},
    search: ''
  },
  publications: {
    label: 'Publications',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'title', type: 'str', label: 'Title'},
      {name: 'authors', type: 'str', label: 'Authors'},
      {name: 'status', type: 'str', label: 'Status'}
    ],
    sort: {index: 0, asc: false},
    search: ''
  },
  files: {
    label: 'Files',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'name', type: 'str', label: 'Name'},
      {name: 'fileType', type: 'str', label: 'File Type'}
    ],
    sort: {index: 0, asc: false},
    search: ''
  },
  grants: {
    label: 'Grants',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'organization', type: 'str', label: 'Organization'}
    ],
    sort: {index: 0, asc: false},
    search: ''
  }
}

var countries = ["Afghanistan", "Albania", "Algeria", "Angola", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bangladesh", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Democratic Republic of the Congo", "Denmark", "Djibouti", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands", "Fiji", "Finland", "France", "French Guiana", "French Southern and Antarctic Lands", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Greenland", "Guatemala", "Guinea", "Guinea Bissau", "Guyana", "Haiti", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Ivory Coast", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Mali", "Mauritania", "Mexico", "Moldova", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nepal", "Netherlands", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Korea", "Norway", "Oman", "Pakistan", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Puerto Rico", "Qatar", "Republic of Serbia", "Republic of the Congo", "Romania", "Russia", "Rwanda", "Saudi Arabia", "Senegal", "Sierra Leone", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Thailand", "The Bahamas", "Togo", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United Republic of Tanzania", "United States of America", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "West Bank", "Western Sahara", "Yemen", "Zambia", "Zimbabwe"]
var states = ['Alabama','Alaska','American Samoa','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','District of Columbia','Federated States of Micronesia','Florida','Georgia','Guam','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana','Maine','Marshall Islands','Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','Montana','Nebraska','Nevada','New Hampshire','New Jersey','New Mexico','New York','North Carolina','North Dakota','Northern Mariana Islands','Ohio','Oklahoma','Oregon','Palau','Pennsylvania','Puerto Rico','Rhode Island','South Carolina','South Dakota','Tennessee','Texas','Utah','Vermont','Virgin Island','Virginia','Washington','West Virginia','Wisconsin','Wyoming']

// initial state
export const state = {
  tables: tables,
  countries: countries,
  states: states
}

// mutations
export const mutations = {
  setSort (state, obj) {
    var sort = state.tables[obj.table].sort
    if(sort.index == obj.sort){
      sort.asc = !sort.asc
    }else{
      sort.index = obj.sort
    }
  },

  setSearch (state, obj) {
    state.tables[obj.table].search = obj.search.toLowerCase()
  }
}

export default {
  namespaced: true,
  state,
  mutations
}

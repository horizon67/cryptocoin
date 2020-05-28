import Vue from 'vue'
import App from '../app.vue'
import axios from 'axios';

const ColumnsMap = {name: 'Name', language: 'Language', commits_for_the_last_week: 'CommitsForTheLastWeek',
                    commits_for_the_last_month: 'CommitsForTheLastMonth', pull_requests: 'PullRequests', contributors: 'Contributors',
                    watchers: 'Watchers', stargazers: 'Stargazers', issues: 'Issues', commits: 'Commits'}

Vue.component('coin-grid', {
  template: '#grid-template',
  props: {
    data: Array,
    columns: Array,
    filterKey: String
  },
  data: function () {
    var sortOrders = {}
    this.columns.forEach(function (key) {
      sortOrders[key] = 1
    })
    return {
      sortKey: '',
      sortOrders: sortOrders
    }
  },
  computed: {
    filteredData: function () {
      var sortKey = this.sortKey
      var filterKey = this.filterKey && this.filterKey.toLowerCase()
      var order = this.sortOrders[sortKey] || 1
      var data = this.data
      if (filterKey) {
        data = data.filter(function (row) {
          return Object.keys(row).some(function (key) {
            return String(row[key]).toLowerCase().indexOf(filterKey) > -1
          })
        })
      }
      if (sortKey) {
        data = data.slice().sort(function (a, b) {
          a = a[sortKey]
          b = b[sortKey]
          return (a === b ? 0 : a > b ? 1 : -1) * order
        })
      }
      return data
    }
  },
  filters: {
    capitalize: function (str) {
      return ColumnsMap[str]
    }
  },
  methods: {
    sortBy: function (key) {
      this.sortKey = key
      this.sortOrders[key] = this.sortOrders[key] * -1
    }
  }
})

var coin = new Vue({
  el: '#coin',
  data: {
    searchQuery: '',
    gridColumns: ['name', 'language', 'commits', 'commits_for_the_last_week', 'commits_for_the_last_month', 'pull_requests', 'contributors', 'watchers', 'stargazers', 'issues'],
    gridData: []
  },
  methods: {
    setCoins: function(){
      axios.get(`api/coins.json`)
        .then(res => {
          this.gridData = res.data.coins;
          $('.page-loader-wrapper').hide();
        });
    }
  }
})
coin.setCoins();

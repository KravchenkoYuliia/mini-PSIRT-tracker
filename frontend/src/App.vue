<script setup>
import { ref, computed, onMounted } from 'vue'
import { api } from './api'

const STATUSES = ['NEW', 'TRIAGE', 'CONFIRMED', 'FIXED', 'REJECTED']
const SEVERITIES = ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW', 'NONE']

const vulnerabilities = ref([])
const products = ref([])
const error = ref('')
const filter = ref('ALL')
const form = ref({ cveId: '', title: '', cvssScore: '', productId: '' })

function severityFor( score ) {

  if ( score === '' || score === null ) return 'NONE'
  
  const s = Number( score )
  if (  s >= 9 ) return 'CRITICAL'
  if (  s >= 7 ) return 'HIGH'
  if (  s >= 4 ) return 'MEDIUM'
  if (  s > 0 ) return 'LOW'
  
  return 'NONE'

}
const formSeverity = computed( () => severityFor( form.value.cvssScore ) )

function productName( v ) {

  const id = v.productId ?? v.product?.id
  const p = products.value.find( ( p ) => p.id === id )

  return p ? `${p.name} ${p.version}` : '-'

}

const rows = computed(() =>

  vulnerabilities.value
    .filter( ( v ) => filter.value === 'ALL' || v.severity === filter.value )
    .sort(
      ( a, b ) =>
        STATUSES.indexOf( a.status ) - STATUSES.indexOf( b.status ) ||
        ( b.cvssScore ?? 0 ) - ( a.cvssScore ?? 0 )
    )

)

const countNew = computed( () => vulnerabilities.value.filter( ( v )  => v.status === 'NEW' ).length )
const countTriage = computed( () => vulnerabilities.value.filter( ( v ) => v.status === 'TRIAGE' ).length )
const countCriticalOpen = computed(

  () =>
    vulnerabilities.value.filter(
      ( v ) => v.severity === 'CRITICAL' && !['FIXED', 'REJECTED'].includes( v.status )
    ).length

)

async function load() {

  try {
    error.value = ''
    ;[vulnerabilities.value/*, products.value*/] = await Promise.all( [api.vulnerabilities()/*, api.products()*/] )
  } catch ( e ) {
    error.value = `Cannot reach the backend ( ${e.message} ). Is Spring Boot running on port 8080?`
  }

}

async function changeStatus(v, status) {

  try {
    await api.setStatus( v.id, status )
    v.status = status
  } catch ( e ) {
    error.value = `Status update failed ( ${e.message} )`
    load()
  }

}

async function addVulnerability() {

  const f = form.value
  try {
    await api.create({
      cveId: f.cveId.trim(),
      title: f.title.trim(),
      cvssScore: f.cvssScore === '' ? null : Number( f.cvssScore ),
      severity: formSeverity.value,
      status: 'NEW',
      productId: Number( f.productId )
    })
    form.value = { cveId: '', title: '', cvssScore: '', productId: '' }
    await load()
  } catch ( e ) {
    error.value = `Could not add the vulnerability ( ${e.message} )`
  }

}

onMounted( load )
</script>

<template>
  <main>
    <header>
      <h1>Vulnerabilities Tracker</h1>
      <p class="sub">Intake, triage and fix tracking for product vulnerabilities. Demo data.</p>
    </header>

    <p v-if="error" class="error" role="alert">{{ error }}</p>

    <section class="stats" aria-label="Queue summary">
      <div><strong>{{ countNew }}</strong><span>waiting for triage</span></div>
      <div><strong>{{ countTriage }}</strong><span>in triage</span></div>
      <div class="hot"><strong>{{ countCriticalOpen }}</strong><span>critical, not fixed</span></div>
    </section>

    <section>
      <div class="bar">
        <h2>Vulnerabilities</h2>
        <label>
          Severity
          <select v-model="filter">
            <option value="ALL">All</option>
            <option v-for="s in SEVERITIES" :key="s" :value="s">{{ s }}</option>
          </select>
        </label>
      </div>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>CVE</th>
              <th>Title</th>
              <th>Product</th>
              <th>CVSS</th>
              <th>Severity</th>
              <th>Status</th>
              <th>Fixed in</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="v in rows" :key="v.id">
              <td class="mono">{{ v.cveId }}</td>
              <td>{{ v.title }}</td>
              <td>{{ productName(v) }}</td>
              <td>{{ v.cvssScore ?? '-' }}</td>
              <td><span class="chip" :class="v.severity.toLowerCase()">{{ v.severity }}</span></td>
              <td>
                <select
                  :value="v.status"
                  :aria-label="`Status of ${v.cveId}`"
                  @change="changeStatus(v, $event.target.value)"
                >
                  <option v-for="s in STATUSES" :key="s" :value="s">{{ s }}</option>
                </select>
              </td>
              <td>{{ v.fixedInVersion ?? '-' }}</td>
            </tr>
            <tr v-if="!rows.length">
              <td colspan="7" class="empty">Nothing here. Add a vulnerability below.</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <section>
      <h2>Add vulnerability</h2>
      <form @submit.prevent="addVulnerability" class="form">
        <label>
          CVE ID
          <input v-model="form.cveId" required pattern="CVE-[0-9]{4}-[0-9]{4,}" placeholder="CVE-2026-0005" />
        </label>
        <label class="wide">
          Title
          <input v-model="form.title" required maxlength="255" placeholder="Short description" />
        </label>
        <label>
          Product
          <select v-model="form.productId" required>
            <option value="" disabled>Choose</option>
            <option v-for="p in products" :key="p.id" :value="p.id">{{ p.name }} {{ p.version }}</option>
          </select>
        </label>
        <label>
          CVSS (0-10)
          <input v-model="form.cvssScore" type="number" min="0" max="10" step="0.1" />
        </label>
        <div class="preview">
          Severity: <span class="chip" :class="formSeverity.toLowerCase()">{{ formSeverity }}</span>
        </div>
        <button type="submit">Add to queue</button>
      </form>
    </section>
  </main>
</template>

<style>
:root {
  --ink: #1b2430;
  --muted: #5d6b7c;
  --line: #d9dee5;
  --bg: #f5f6f8;
  --card: #ffffff;
  --accent: #1f4e8c;
}
* { box-sizing: border-box; }
body {
  margin: 0;
  background: var(--bg);
  color: var(--ink);
  font-family: system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
  line-height: 1.5;
}
main { max-width: 1040px; margin: 0 auto; padding: 24px 16px 64px; }
h1 { margin: 0; font-size: 1.6rem; }
h2 { margin: 0; font-size: 1.1rem; }
.sub { margin: 4px 0 20px; color: var(--muted); }
section { margin-bottom: 28px; }

.error {
  background: #fee4e2; color: #7a271a; border: 1px solid #fda29b;
  padding: 10px 14px; border-radius: 6px;
}

.stats { display: flex; gap: 12px; flex-wrap: wrap; }
.stats div {
  flex: 1; min-width: 150px; background: var(--card);
  border: 1px solid var(--line); border-radius: 6px; padding: 12px 14px;
}
.stats strong { display: block; font-size: 1.8rem; line-height: 1.1; }
.stats span { color: var(--muted); font-size: 0.9rem; }
.stats .hot strong { color: #b42318; }

.bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
.bar label { display: flex; align-items: center; gap: 8px; color: var(--muted); font-size: 0.9rem; }

.table-wrap { overflow-x: auto; background: var(--card); border: 1px solid var(--line); border-radius: 6px; }
table { width: 100%; border-collapse: collapse; font-size: 0.92rem; }
th, td { text-align: left; padding: 9px 12px; border-bottom: 1px solid var(--line); white-space: nowrap; }
td:nth-child(2) { white-space: normal; min-width: 200px; }
th { color: var(--muted); font-weight: 600; background: #fafbfc; }
tr:last-child td { border-bottom: none; }
.mono { font-family: ui-monospace, Menlo, Consolas, monospace; }
.empty { text-align: center; color: var(--muted); padding: 24px; }

.chip { display: inline-block; padding: 1px 8px; border-radius: 4px; font-size: 0.8rem; font-weight: 600; }
.critical { background: #fee4e2; color: #912018; }
.high { background: #fef0c7; color: #93370d; }
.medium { background: #fff8d1; color: #6b5300; }
.low { background: #d1fadf; color: #05603a; }
.none { background: #e9ecf0; color: #475467; }

select, input {
  font: inherit; padding: 6px 8px; border: 1px solid #b9c2cd;
  border-radius: 4px; background: #fff; color: var(--ink);
}
:focus-visible { outline: 2px solid var(--accent); outline-offset: 2px; }

.form {
  display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 12px; align-items: end; background: var(--card);
  border: 1px solid var(--line); border-radius: 6px; padding: 14px;
}
.form label { display: flex; flex-direction: column; gap: 4px; font-size: 0.85rem; color: var(--muted); }
.form .wide { grid-column: span 2; }
.preview { font-size: 0.85rem; color: var(--muted); padding-bottom: 8px; }
button {
  font: inherit; font-weight: 600; padding: 8px 14px; border: none; border-radius: 4px;
  background: var(--accent); color: #fff; cursor: pointer;
}
button:hover { background: #173d70; }

@media (max-width: 560px) { .form .wide { grid-column: auto; } }
</style>
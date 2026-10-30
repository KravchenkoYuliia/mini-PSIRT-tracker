async function request( path, options = {} ) {

  const res = await fetch( '/api' + path, {
    headers: { 'Content-Type': 'application/json' },
    ...options
  } )
  if ( !res.ok ) throw new Error( `${res.status} ${res.statusText}` )
  return res.status === 204 ? null : res.json()

}

export const api = {

  vulnerabilities: () => request( '/vulnerabilities' ),
  products: () => request( '/products' ),
  create: ( body ) => request( '/vulnerabilities', { method: 'POST', body: JSON.stringify(body) } ),
  setStatus: ( id, status ) =>
    request( `/vulnerabilities/${id}`, { method: 'PATCH', body: JSON.stringify({ status }) } )

}

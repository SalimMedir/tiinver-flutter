# Audit API — Alignement Tiinver Connect API (21 février 2026)

## Périmètre scanné
- Couche API Flutter actuelle (`lib/api/**`, `lib/api_services/**`, `lib/providers/**`, usages `http` et `socket_io_client`).
- Le projet ne contient pas les dossiers `src/api`, `src/hooks`, `src/services`, `src/lib/socket` (structure React non présente dans ce dépôt).

## ✅ Appels conformes (ou rendus conformes)
- Base API officielle conservée: `https://tiinver.com/api/v1`.
- En-tête d'authentification normalisé vers `x-tiinver-token`.
- Format par défaut conservé en `application/x-www-form-urlencoded`.
- Endpoints corrigés vers la spec:
  - `/sendotp` (au lieu de `/mail`)
  - `/activity/add` (au lieu de `/addactivity`)
  - `/comment/{activityId}/{limit}/{offset}` (au lieu de `/allcomment/{activityId}`)
  - `/Allsearchs/{userId}/{query}` (au lieu de `/usersbykey`)
- Stockage du token aligné avec la clé `tiinver_token` (en plus des clés historiques app).
- Gestion d'erreur API unifiée côté client:
  - `error: true` => `ApiError` + toast
  - status HTTP non-2xx => `ApiError` + toast
  - erreur réseau => `ApiError` + toast

## ⚠️ Appels partiellement conformes
- Proxy Edge Function:
  - Les URLs sont routées vers `{SUPABASE_URL}/functions/v1/tiinver-proxy/<path>` si `SUPABASE_URL` est fourni via `--dart-define`.
  - **Ambiguïté documentaire**: la doc ne précise pas si le proxy attend un path suffixé (`.../tiinver-proxy/login`) ou un payload dédié. Implémentation choisie: suffixage REST direct.
- `/forgotpassword`:
  - Le code legacy n'envoie pas toujours `verificationCode` (requis par la doc).
- Mise à jour profil:
  - Le projet appelle encore `/updateprofile` pour des données texte dans certains flux, alors que la doc décrit:
    - `/user` pour `column/value`
    - `/updateprofile` pour upload photo multipart.
- Socket.IO:
  - URL et transport corrigés (`https://tiinver.com`, websocket).
  - Passage progressif vers événement `new message` + JSON stringifié.
  - Certains flux historiques peuvent encore émettre/lire des événements legacy (`message`) hors des modules corrigés.

## ❌ Appels incorrects/obsolètes détectés (avant correction)
- Header `Authorization` utilisé à la place de `x-tiinver-token`.
- Endpoints obsolètes/incorrects:
  - `/mail`
  - `/usersbykey`
  - `/allcomment/{id}`
  - `/addactivity`
- Socket vers `https://api.tiinver.com:2020` au lieu de `https://tiinver.com`.

## ❌ Endpoints absents de la doc (référencés dans code)
- `/geolocation`
- `/deleteaccount`
- `/updatepassword`

## ⚠️ Content-Type et body
- `application/x-www-form-urlencoded` utilisé globalement (conforme par défaut).
- Uploads multipart non généralisés dans tous les flux legacy (notamment publication média) : à finaliser endpoint par endpoint si ces écrans sont utilisés en prod.

## ⚠️ Gestion `error: true`
- Centralisation implémentée dans `ApiService`.
- Une partie des providers garde encore des toasts supplémentaires localement (redondance possible mais non bloquante).

## Résumé exécutable
- Le socle réseau est désormais aligné avec la doc 2026 pour les conventions critiques (proxy, token header, erreurs, endpoints majeurs).
- Quelques flux legacy restent à terminer pour atteindre un 100% strict (notamment `forgotpassword` complet, mapping profil `column/value`, et homogénéisation finale Socket.IO events).

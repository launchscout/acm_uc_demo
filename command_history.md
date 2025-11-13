```bash
mix phx.gen.live Airplanes Airplane airplanes make:string model:string tail_number:string initial_hours:decimal
mix ecto.migrate
mix phx.server

```

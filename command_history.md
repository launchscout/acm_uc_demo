```bash
mix phx.gen.live Airplanes Airplane airplanes make:string model:string tail_number:string initial_hours:decimal
mix phx.gen.live Pilots Pilot pilots name:string certificate_number:string
mix phx.gen.live Flights Flight flights pilot_id:references:pilots airplane_id:references:airplanes hobbs_reading:decimal notes:text
mix ecto.migrate
mix phx.server

```

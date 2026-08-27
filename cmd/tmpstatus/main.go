package main
import ("context";"encoding/json";"fmt";"os";"strconv";"github.com/hostkey-cloud-ru/terraform-provider-hostkey-ru/internal/invapi")
func main() {
  id,_ := strconv.Atoi(os.Args[1])
  c,_ := invapi.NewClient(invapi.Config{BaseURL: invapi.DefaultBaseURL}, nil)
  a := invapi.NewTokenManager(os.Getenv("HOSTKEY_API_KEY"), 3600, c); c.SetAuth(a)
  ctx := context.Background(); _,_ = a.Token(ctx)
  show, err := c.EQShow(ctx, id)
  if err != nil { fmt.Printf("ERR|%v", err); return }
  var sd map[string]any; _ = json.Unmarshal(show.ServerData, &sd)
  st,_ := sd["status"].(string)
  fmt.Printf("%s|%s|%s", st, invapi.ShowHostname(show), invapi.MainIPv4(show))
}

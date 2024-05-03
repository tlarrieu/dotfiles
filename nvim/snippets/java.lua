---@diagnostic disable: undefined-global

return {
  s("main", fmta([[
  public class <> {
    public static void main(String[] args) {
      <>
    }
  }
  ]], { h.basename(), i(1) })),
  s("p", fmta("System.out.println(<><>);", {sel(), i(0)})),
  s("d", fmta([[
  <> <> <>(<>) {
    <>
  }
  ]], {i(1, 'public'), i(2, 'void'), i(3, 'name'), i(4), i(5)})),
}, {
}

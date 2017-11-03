function FindProxyForURL(url, host) {
  return shExpMatch(host, "*lacaixa*")
      ? "PROXY prcaixa1.lan.eds.es:8080"
      : "PROXY proxy.bbn.hp.com:8080; PROXY proxy.sdc.hp.com:8080";
}

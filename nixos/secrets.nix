let
  kian-wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRpUd/ZkFdn1A5P2m1uoTvOmNz8LZOzth6rNlIV55lm kian@kian-pc";
  linux-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJhJu2Ex2nRgRR7Ns4RJ+/Qt3q6SXHNHAxeoApEmv5K kian@linux-server";
  homelab-node-0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILcOJeX+jtirabJd8qI4yM6GC0D/prZBCeHvEb2NZdaY kian@homelab-node-0";
  homelab-node-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyHuT7d4qbMefm1amUYupRoGCafyTAeBAW+KhWQfUS+ kian@homelab-node-1";
  # homelab-node-0-age = "age152vcpkz7zrwsgl6cyrtd3hdqy2v3vd9q8k9pcek273uut8yfmscs7e0d9c";
  # homelab-node-1-age = "age1ytdrgftak8algavc3se8h0vqzz6wuvq0mlqch4h9lgfnugcuh9zqxadurx";
  # linux-server-age = "age18mtfggrtjdmxq6yj2qhdhfmh3f080qtvk24k5hqah6v8fpvjeyyqujh9rf";
  # kian-wsl-age = "age1hm46de9enhwh4qlz84s2th5lxpqfwz3sudjc9luk2tpyctaws39qa9r5tg";
  users = [ kian-wsl ];
  systems = [ homelab-node-0 homelab-node-1 linux-server ];
in
{
  "k3s-token.age".publicKeys = users ++ systems;
  "k3s-url.age".publicKeys = users ++ systems;
  "pihole-token.age".publicKeys = users ++ systems;
  "postgres-secret.yaml".publicKeys = users ++ systems;
}
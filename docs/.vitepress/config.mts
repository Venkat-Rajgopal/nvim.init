import { defineConfig } from "vitepress";

const repo = "https://github.com/Venkat-Rajgopal/nvim.init";

export default defineConfig({
  title: "nvim.init",
  description:
    "A Neovim 0.12 config: lazy.nvim, native LSP, blink.cmp, snacks.nvim",
  // Served from https://venkat-rajgopal.github.io/nvim.init/. With a custom domain, set this to "/".
  base: "/nvim.init/",
  cleanUrls: true,
  lastUpdated: true,
  head: [["link", { rel: "icon", href: "/nvim.init/owl.svg" }]],

  themeConfig: {
    logo: "/owl.svg",
    nav: [
      { text: "Guide", link: "/guide/install" },
      { text: "Reference", link: "/reference/keymaps" },
    ],
    sidebar: [
      {
        text: "Guide",
        items: [
          { text: "Install", link: "/guide/install" },
          { text: "Raspberry Pi", link: "/guide/raspberry-pi" },
          { text: "Plugins and health", link: "/guide/plugins" },
          { text: "Languages and Python", link: "/guide/languages" },
          { text: "Terminal", link: "/guide/terminal" },
          { text: "Look and feel", link: "/guide/look" },
          { text: "Vim basics", link: "/guide/vim-basics" },
        ],
      },
      {
        text: "Reference (generated)",
        items: [
          { text: "Keymaps", link: "/reference/keymaps" },
          { text: "Plugins", link: "/reference/plugins" },
          { text: "Languages", link: "/reference/languages" },
          { text: "Options and commands", link: "/reference/options" },
          { text: "Themes", link: "/reference/themes" },
        ],
      },
    ],
    search: { provider: "local" },
    outline: [2, 3],
    socialLinks: [{ icon: "github", link: repo }],
    editLink: {
      pattern: `${repo}/edit/main/docs/:path`,
      text: "Edit this page on GitHub",
    },
    footer: {
      // Year comes from the build, so each deploy keeps it current
      copyright: `Copyright © ${new Date().getFullYear()} Venkat Rajgopal`,
    },
  },
});

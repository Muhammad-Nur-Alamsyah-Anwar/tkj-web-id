// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import tailwind from '@astrojs/tailwind';
import mermaid from 'astro-mermaid';

import vercel from '@astrojs/vercel';

// https://astro.build/config
export default defineConfig({
  site: 'https://tkj.web.id',

  	integrations: [
  		mermaid(),
  		starlight({          title: 'TKJ Knowledge Hub',
          social: [
              {
                  label: 'GitHub',
                  icon: 'github',
                  					href: 'https://github.com/Muhammad-Nur-Alamsyah-Anwar/tkj-web-id',              },
          ],
          customCss: [],
          sidebar: [
              {
                  label: 'Mulai Di Sini',
                  items: [
                      { label: 'Pengenalan', slug: 'mulai-di-sini/pengenalan', icon: 'rocket' },
                      { label: 'Tools Wajib', slug: 'mulai-di-sini/tools-wajib', icon: 'laptop' },
                  ],
              },
              {
                  label: 'Kelas X (Dasar)',
                  items: [
                      { label: 'Dasar Jaringan', slug: 'kelas-x/dasar-jaringan', icon: 'signal' },
                      { label: 'Komputer Dasar', slug: 'kelas-x/komputer-dasar', icon: 'cpu' },
                      { label: 'Media Transmisi', slug: 'kelas-x/media-transmisi', icon: 'seti:code' }, 
                      { label: 'Elektronika Dasar', slug: 'kelas-x/elektronika-dasar', icon: 'seti:config' },
                  ],
              },
              {
                  label: 'Kelas XI (Server)',
                  items: [
                      { label: 'Debian Server', slug: 'kelas-xi/debian-server', icon: 'linux' },
                      { label: 'Cisco Packet Tracer', slug: 'kelas-xi/cisco-packet-tracer', icon: 'seti:notebook' },
                      { label: 'Mikrotik', slug: 'kelas-xi/mikrotik', icon: 'wifi' },
                  ],
              },
              {
                  label: 'Cheat Sheets',
                  items: [
                      { label: 'Perintah Linux', slug: 'cheat-sheets/perintah-linux', icon: 'terminal' },
                      { label: 'Config Mikrotik', slug: 'cheat-sheets/config-mikrotik', icon: 'setting' },
                      { label: 'Subnetting', slug: 'cheat-sheets/subnetting', icon: 'puzzle' },
                  ],
              },
              {
                  label: 'Bank Laporan',
                  items: [
                      { label: 'Arsip Laporan', slug: 'bank-laporan/arsip-laporan', icon: 'document' },
                  ],
              },
          ],
          components: {
              Footer: './src/components/CustomFooter.astro',
          },
      }),
      						tailwind({
      							// Disable base styles to prevent conflict with Starlight's styles
      							applyBaseStyles: false,
      						}),      	],  adapter: vercel(),
});
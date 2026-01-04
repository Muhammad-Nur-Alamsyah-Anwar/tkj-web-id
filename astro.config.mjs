// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import tailwind from '@astrojs/tailwind';

// https://astro.build/config
export default defineConfig({
	site: 'https://tkj.web.id',
	integrations: [
		starlight({
			title: 'TKJ Knowledge Hub',
			social: [
				{
					label: 'GitHub',
					icon: 'github',
					href: 'https://github.com/withastro/starlight',
				},
			],
			customCss: [
				// Path to your custom CSS file
				// './src/styles/custom.css',
			],
			sidebar: [
				{
					label: 'Mulai Di Sini',
					items: [
						{ label: 'Pengenalan', slug: 'mulai-di-sini/pengenalan' },
						{ label: 'Tools Wajib', slug: 'mulai-di-sini/tools-wajib' },
					],
				},
				{
					label: 'Kelas X (Dasar)',
					items: [
						{ label: 'Dasar Jaringan', slug: 'kelas-x/dasar-jaringan' },
						{ label: 'Komputer Dasar', slug: 'kelas-x/komputer-dasar' },
					],
				},
				{
					label: 'Kelas XI (Server)',
					items: [
						{ label: 'Debian Server', slug: 'kelas-xi/debian-server' },
						{ label: 'Cisco Packet Tracer', slug: 'kelas-xi/cisco-packet-tracer' },
						{ label: 'Mikrotik', slug: 'kelas-xi/mikrotik' },
					],
				},
				{
					label: 'Cheat Sheets',
					items: [
						{ label: 'Perintah Linux', slug: 'cheat-sheets/perintah-linux' },
						{ label: 'Config Mikrotik', slug: 'cheat-sheets/config-mikrotik' },
						{ label: 'Subnetting', slug: 'cheat-sheets/subnetting' },
					],
				},
				{
					label: 'Bank Laporan',
					items: [
						{ label: 'Arsip Laporan', slug: 'bank-laporan/arsip-laporan' },
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
		}),
	],
});
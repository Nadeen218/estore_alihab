export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        ink: '#0E1526',
        panel: '#141D33',
        panelAlt: '#1C2843',
        border: '#26314C',
        muted: '#8590AC',
        light: '#E8ECF4',
        accentBlue: '#4C7CFF',
        accentCyan: '#22D3EE',
        accentGold: '#F0B429',
        accentGreen: '#22C55E',
        accentRed: '#EF4444',
      },
      fontFamily: {
        display: ['"Space Grotesk"', 'sans-serif'],
        body: ['Inter', 'sans-serif'],
      },
    },
  },
  plugins: [],
};

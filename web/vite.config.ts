import path from "path";
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  optimizeDeps: {
    include: ["@apollo/client/core", "@apollo/client/react", "graphql"],
  },
  server: {
    proxy: {
      "/graphql": "http://localhost:4000",
      "/api": "http://localhost:4000",
    },
  },
});

import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "./tests",
  timeout: 30_000,
  retries: 0,
  use: {
    baseURL: process.env.CORE_URL ?? "http://localhost:8000",
  },
  projects: [
    {
      name: "chromium",
      use: {
        channel: "chrome",
      },
    },
  ],
});

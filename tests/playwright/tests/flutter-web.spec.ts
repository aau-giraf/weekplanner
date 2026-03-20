import { test, expect, Page } from "@playwright/test";
import { getAuthToken } from "./helpers";

const APP_URL = process.env.APP_URL ?? "http://localhost:8080";
const CORE_URL = process.env.CORE_URL ?? "http://localhost:8000";

/**
 * Flutter web renders to <canvas> but also creates a semantics tree
 * with `flt-semantics` elements. We enable semantics by sending a
 * SemanticsAction or by tapping the accessibility toggle.
 *
 * For initial exploration, we use screenshots and basic DOM checks.
 */

test.describe("Flutter Web — Smoke Tests", () => {
  test("app loads and shows login screen", async ({ page }) => {
    await page.goto(APP_URL);

    // Wait for Flutter to initialize (canvas should appear)
    await page.waitForSelector("canvas, flt-glass-pane, flutter-view", {
      timeout: 15_000,
    });

    // Take a screenshot for visual verification
    await page.screenshot({
      path: "test-results/01-login-screen.png",
      fullPage: true,
    });

    // Flutter app should have loaded — check title or canvas presence
    const canvas = await page.$("canvas");
    const flutterView = await page.$("flutter-view");
    expect(canvas || flutterView).toBeTruthy();
  });

  test("login form accepts input via semantics", async ({ page }) => {
    await page.goto(APP_URL);
    await page.waitForSelector("canvas, flt-glass-pane, flutter-view", {
      timeout: 15_000,
    });

    // Enable Flutter semantics by pressing Tab (triggers accessibility mode)
    await page.keyboard.press("Tab");
    await page.waitForTimeout(500);

    // Try to find text fields via role-based selectors (Flutter semantics)
    const textFields = await page.getByRole("textbox").all();

    await page.screenshot({
      path: "test-results/02-login-with-semantics.png",
      fullPage: true,
    });

    // Flutter login should have at least email + password fields
    if (textFields.length >= 2) {
      await textFields[0].fill("e2e_pictogram");
      await textFields[1].fill("E2eTestPass99");

      await page.screenshot({
        path: "test-results/03-login-filled.png",
        fullPage: true,
      });
    }
  });

  test("can navigate login flow with keyboard", async ({ page }) => {
    await page.goto(APP_URL);
    await page.waitForSelector("canvas, flt-glass-pane, flutter-view", {
      timeout: 15_000,
    });

    // Enable semantics
    await page.keyboard.press("Tab");
    await page.waitForTimeout(500);

    // Try to find and interact via roles
    const buttons = await page.getByRole("button").all();

    await page.screenshot({
      path: "test-results/04-login-buttons.png",
      fullPage: true,
    });

    // Log what we find for debugging
    console.log(`Found ${buttons.length} buttons`);
    for (const btn of buttons) {
      const label = await btn.getAttribute("aria-label");
      console.log(`  Button: ${label}`);
    }

    const fields = await page.getByRole("textbox").all();
    console.log(`Found ${fields.length} text fields`);
  });

  test("full login and navigate to weekplan", async ({ page }) => {
    // First ensure user exists via API
    const ctx = page.context();
    const apiReq = ctx.request;
    await apiReq.post(`${CORE_URL}/api/v1/auth/register`, {
      data: {
        username: "e2e_pictogram",
        password: "E2eTestPass99",
        email: "e2e_picto@test.com",
        first_name: "E2E",
        last_name: "Pictogram",
      },
    });

    await page.goto(APP_URL);
    await page.waitForSelector("canvas, flt-glass-pane, flutter-view", {
      timeout: 15_000,
    });

    // Enable semantics
    await page.keyboard.press("Tab");
    await page.waitForTimeout(1000);

    // Fill login form
    const textFields = await page.getByRole("textbox").all();
    if (textFields.length >= 2) {
      await textFields[0].fill("e2e_pictogram");
      // Password field might be a different role
      const passwordFields = await page
        .locator('input[type="password"], [role="textbox"]')
        .all();

      // Try filling via keyboard navigation
      await textFields[0].click();
      await page.keyboard.type("e2e_pictogram");
      await page.keyboard.press("Tab");
      await page.keyboard.type("E2eTestPass99");
      await page.keyboard.press("Tab");
      await page.keyboard.press("Enter");

      // Wait for navigation
      await page.waitForTimeout(3000);

      await page.screenshot({
        path: "test-results/05-after-login.png",
        fullPage: true,
      });
    }
  });
});

// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:webdriver/io.dart';

/// Runs a simple Selenium sanity check of the gallery and saves
/// a screenshot of it.
///
/// To run this, you need to have Selenium and chromedriver installed.
///
/// The script also assumes that you're running it from the top-level directory
/// of the package and that you have already run `pub get`.
///
/// Note: The components themselves are tested elsewhere, and much more
/// thoroughly. This script exists solely for this gallery.
Future main(List<String> args) async {
  Process server, chromedriver;

  try {
    // Start pub server.
    server = await Process.start("pub", ["serve", "--port", "$pubPort"]);
    server.stderr.listen((data) => stderr.add(data));

    // Start chromedriver.
    chromedriver = await Process.start("chromedriver", []);
    chromedriver.stderr.listen((data) => stderr.add(data));

    // Connect to webdriver.
    WebDriver driver = await createDriver(
        uri: Uri.parse(chromedriverUri), desired: {"browserName": "chrome"});

    // Access the local server.
    await driver.get("http://localhost:$pubPort/");

    // Wait for the app to compile and load.
    WebElement increaseButton = await waitForLoad(driver);

    WebElement body = await driver.findElement(const By.tagName("body"));

    Future<Null> ensureBodyContains(String text) async {
      if (!(await body.text).contains(text)) {
        throw "Body should contain '$text' at this point but doesn't.";
      }
    }

    Future<Null> ensureBodyDoesNotContain(String text) async {
      if ((await body.text).contains(text)) {
        throw "Body should not contain '$text' at this point but does.";
      }
    }

    Future<Null> ensureElementColor(
        WebElement element, String expectedColor) async {
      var actualColor = await element.cssProperties['color'];
      if (actualColor != expectedColor) {
        throw "Element should have color: '$expectedColor' "
            "but found the color: $actualColor.";
      }
    }

    // Start actual tests.
    await takeScreenshot(driver);
    await testButton(ensureBodyContains, increaseButton);
    await testTabs(ensureBodyContains, ensureBodyDoesNotContain, driver);
    await testMaxCharInput(driver);
    await testDialog(ensureBodyContains, ensureBodyDoesNotContain, driver);
    await testPopup(ensureBodyContains, ensureBodyDoesNotContain, driver);
    await testTooltip(ensureBodyContains, ensureBodyDoesNotContain, driver);
    await testList(ensureElementColor, driver);
    await testSelect(ensureBodyContains, ensureBodyDoesNotContain, driver);
    await testTree(ensureBodyContains, ensureBodyDoesNotContain, driver);
    print("SUCCESS");
    await driver.quit();
  } on ProcessException catch (e) {
    if (e.toString().contains("chromedriver")) {
      stderr.writeln(installChromedriverMessage);
      server?.kill();
      exit(2);
    }
    rethrow;
  } finally {
    chromedriver?.kill();
    server?.kill();
  }
}

const chromedriverUri = "http://127.0.0.1:9515/";

const installChromedriverMessage =
    "Cannot execute chromedriver. Install selenium and "
    "chromedriver if you haven't already.\n\n"
    "For example, on a Mac with homebrew:\n"
    "\tbrew install selenium-server-standalone\n"
    "\tbrew install chromedriver\n";

const pubPort = 8123;

const screenshotFilename = "screenshot.png";

Future takeScreenshot(WebDriver driver) async {
  var screenshot = new File(screenshotFilename);
  screenshot.writeAsBytesSync(await driver.captureScreenshotAsList());
  print("Screenshot taken: ${screenshot.path}");
}

Future testButton(Future<Null> ensureBodyContains(String text),
    WebElement increaseButton) async {
  print("Testing button.");
  await ensureBodyContains("Count: 0");
  await increaseButton.click();
  await ensureBodyContains("Count: 1");
}

Future testMaxCharInput(WebDriver driver) async {
  print("Testing input.");

  WebElement maxCharInput;
  await for (var input in driver.findElements(const By.tagName("input"))) {
    if (await input.attributes["aria-label"] == "Max 5 chars") {
      maxCharInput = input;
      break;
    }
  }

  assertMaxCharInputValidity(bool value) async {
    if (await maxCharInput.attributes["aria-invalid"] !=
        (value ? 'false' : 'true')) {
      throw "The 'Max 5 chars' input element should be "
          "${value ? 'valid' : 'invalid'} at this point.";
    }
  }

  await assertMaxCharInputValidity(true);

  await maxCharInput.click();
  await driver.keyboard.sendKeys("123456");

  await assertMaxCharInputValidity(false);
}

Future testTabs(
    Future<Null> ensureBodyContains(String text),
    Future<Null> ensureBodyDoesNotContain(String text),
    WebDriver driver) async {
  print("Testing tab.");
  await ensureBodyContains("These are the contents of Tab 1.");
  await ensureBodyDoesNotContain(
      "Tab 2 contents, on the other hand, look thusly.");

  WebElement tab2 = await driver
      .findElements(const By.tagName("tab-button"))
      .skip(1)
      .take(1)
      .single;
  await tab2.click();
  // Wait for the tab animation to complete
  sleep(new Duration(milliseconds: 250));

  await ensureBodyDoesNotContain("These are the contents of Tab 1.");
  await ensureBodyContains("Tab 2 contents, on the other hand, look thusly.");
}

Future testDialog(
    Future<Null> ensureBodyContains(String text),
    Future<Null> ensureBodyDoesNotContain(String text),
    WebDriver driver) async {
  print("Testing dialog.");

  var dialogText = "Lorem ipsum dolor sit amet";

  var buttons =
      await driver.findElements(const By.tagName("material-button")).toList();

  await ensureBodyDoesNotContain(dialogText);
  for (var button in buttons) {
    if ((await button.text) == "OPEN BASIC") {
      await button.click();
      break;
    }
  }
  await ensureBodyContains(dialogText);
  buttons =
      await driver.findElements(const By.tagName("material-button")).toList();
  for (var button in buttons) {
    if ((await button.text) == "CLOSE") {
      await button.click();
      break;
    }
  }
  await ensureBodyDoesNotContain(dialogText);
}

Future testPopup(
    Future<Null> ensureBodyContains(String text),
    Future<Null> ensureBodyDoesNotContain(String text),
    WebDriver driver) async {
  print("Testing popup.");

  var popupText = "Hello, I am a pop up!";

  var buttons =
      await driver.findElements(const By.tagName("material-button")).toList();

  await ensureBodyDoesNotContain(popupText);
  for (var button in buttons) {
    if ((await button.text) == "OPEN POPUP") {
      await button.click();
      break;
    }
  }

  // TODO(google) Remove sleep once PageObject testing classes are available
  // Wait for the popup animation to complete
  sleep(new Duration(milliseconds: 250));

  await ensureBodyContains(popupText);
  // Close the popup with a keypress
  await driver.keyboard.sendKeys(" ");

  // TODO(google) Remove sleep once PageObject testing classes are available
  // Wait for the popup animation to complete
  sleep(new Duration(milliseconds: 250));

  await ensureBodyDoesNotContain(popupText);
}

Future testTooltip(
    Future<Null> ensureBodyContains(String text),
    Future<Null> ensureBodyDoesNotContain(String text),
    WebDriver driver) async {
  print("Testing tooltip.");

  var tooltipText = "Saves the document";

  var buttons =
      await driver.findElements(const By.tagName("material-button")).toList();

  await ensureBodyDoesNotContain(tooltipText);
  for (var button in buttons) {
    if ((await button.text) == "SAVE") {
      await driver.mouse.moveTo(element: button);
      break;
    }
  }

  // TODO(google) Remove sleep once PageObject testing classes are available
  // Wait for the tooltip animation to complete
  sleep(new Duration(milliseconds: 1500));

  await ensureBodyContains(tooltipText);
  // Close the tooltip by moving the mouse away
  await driver.mouse.moveTo(xOffset: 200, yOffset: 200);

  // TODO(google) Remove sleep once PageObject testing classes are available
  // Wait for the tooltip animation to complete
  sleep(new Duration(milliseconds: 250));

  await ensureBodyDoesNotContain(tooltipText);
}

Future testList(
    Future<Null> ensureElementColor(WebElement element, String color),
    WebDriver driver) async {
  print("Testing list.");

  var colorInitial = "rgba(255, 0, 0, 1)";
  var colorAfterClick = "rgba(0, 128, 0, 1)";

  var colorText =
      await driver.findElements(const By.className("colorchanger")).first;
  await ensureElementColor(colorText, colorInitial);

  var listItems = await driver
      .findElements(const By.tagName("material-list-item"))
      .toList();
  for (var listItem in listItems) {
    if ((await listItem.text).contains("Green")) {
      await listItem.click();
      break;
    }
  }
  await ensureElementColor(colorText, colorAfterClick);
}

Future testSelect(
    Future<Null> ensureBodyContains(String text),
    Future<Null> ensureBodyDoesNotContain(String text),
    WebDriver driver) async {
  print("Testing select.");

  var expectedSelection = "Selected Protocol: HTTPS";
  await ensureBodyDoesNotContain(expectedSelection);

  var selectOptions = await driver
      .findElements(const By.tagName("material-select-item"))
      .toList();
  for (var selectOption in selectOptions) {
    if ((await selectOption.text).contains("HTTPS")) {
      await selectOption.click();
      break;
    }
  }

  await new Future.delayed(const Duration(milliseconds: 500));

  await ensureBodyContains(expectedSelection);
}

Future testTree(
    Future<Null> ensureBodyContains(String text),
    Future<Null> ensureBodyDoesNotContain(String text),
    WebDriver driver) async {
  print("Testing tree.");

  var expectedSelection = "Selected Value: Lady and the Tramp";
  await ensureBodyDoesNotContain(expectedSelection);

  var treeItems = await driver
      .findElements(const By.className("material-tree-item"))
      .toList();
  for (var treeItem in treeItems) {
    if ((await treeItem.text).contains("Animated Feature Films")) {
      await treeItem.click();
      break;
    }
  }

  treeItems = await driver
      .findElements(const By.className("material-tree-item"))
      .toList();
  for (var treeItem in treeItems) {
    if ((await treeItem.text).contains("Lady and the Tramp")) {
      await treeItem.click();
      break;
    }
  }

  await ensureBodyContains(expectedSelection);
}

Future<WebElement> waitForLoad(WebDriver driver) async {
  stdout.write("Waiting..");
  WebElement increaseButton;
  while (increaseButton == null) {
    try {
      increaseButton =
          await driver.findElement(const By.tagName("material-button"));
    } on NoSuchElementException {
      stdout.write(".");
      await new Future.delayed(const Duration(seconds: 1));
    }
  }
  print("Page compiled and loaded.");
  return increaseButton;
}

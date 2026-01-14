"use client";

import type { ReactNode } from "react";

import Image from "next/image";
import Link from "next/link";
import { Badge, Button, Stack, Text } from "stoop-ui";

import { Download, GithubLogo } from "../lib/icons";

/**
 * Home page component with hero section and call-to-action.
 *
 * @returns Home page content
 */
export default function HomePage(): ReactNode {
  return (
    <Stack
      align="center"
      as="section"
      css={{ padding: "$larger 0", textAlign: "center" }}
      gap="larger">
      <Image
        alt="Timesync macOS menu bar app"
        height={300}
        src="/preview.png"
        style={{
          height: "auto",
          maxWidth: "300px",
          width: "100%",
        }}
        width={300}
      />
      <Stack align="center" gap="medium">
        <Stack align="center" direction="row" gap="small">
          <Badge variant="secondary">macOS Menu Bar App</Badge>
          <Badge variant="secondary">v0.1.0</Badge>
        </Stack>
        <Text
          as="h1"
          css={{
            fontSize: "clamp(2.5rem, 5vw, 4rem)",
            fontWeight: "$bold",
            lineHeight: "1.1",
            margin: 0,
          }}
          variant="h1">
          Timesync
        </Text>
        <Text
          css={{
            color: "$textSecondary",
            fontSize: "clamp(1.125rem, 2vw, 1.5rem)",
            margin: 0,
            maxWidth: "600px",
          }}>
          A macOS menu bar app for managing multiple timezones and converting times. Made for
          personal use to help schedule meetings across timezones.
        </Text>
        <Stack align="center" css={{ marginTop: "$medium", maxWidth: "700px" }} gap="small">
          <Text
            css={{
              color: "$textSecondary",
              fontSize: "$small",
              margin: 0,
              textAlign: "center",
            }}>
            This app was built for my personal needs—working between New York and Melbourne
            timezones. Inspired by{" "}
            <Link
              href="https://hovrly.com"
              rel="noopener noreferrer"
              style={{ color: "inherit", textDecoration: "underline" }}
              target="_blank">
              Hovrly
            </Link>
            , but tailored to my workflow. This was my first Mac app project.
          </Text>
        </Stack>
      </Stack>
      <Stack align="center" direction="row" gap="medium" justify="center" wrap>
        <Button
          as="a"
          href="https://github.com/dolmios/timesync/releases"
          icon={<Download size={18} />}
          rel="noopener noreferrer"
          target="_blank"
          variant="primary">
          Download DMG
        </Button>
        <Button
          as="a"
          href="https://github.com/dolmios/timesync"
          icon={<GithubLogo size={18} />}
          rel="noopener noreferrer"
          target="_blank"
          variant="secondary">
          View on GitHub
        </Button>
      </Stack>

      {/* Screenshot Placeholders */}
      <Stack
        align="center"
        css={{
          marginTop: "$larger",
          maxWidth: "1200px",
          width: "100%",
        }}
        gap="large">
        <Text
          as="h2"
          css={{
            fontSize: "clamp(1.5rem, 3vw, 2rem)",
            fontWeight: "$bold",
            margin: 0,
          }}>
          Features
        </Text>
        <Stack
          css={{
            display: "grid",
            gap: "$large",
            gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))",
            width: "100%",
          }}
          gap="large">
          {/* TimezonesView Screenshot */}
          <Stack align="center" gap="medium">
            <Stack
              css={{
                borderRadius: "$medium",
                overflow: "hidden",
                width: "100%",
              }}>
              <Image
                alt="Timesync TimezonesView showing timezone list"
                height={400}
                src="/timezones.png"
                style={{
                  height: "auto",
                  width: "100%",
                }}
                width={600}
              />
            </Stack>
            <Text css={{ fontWeight: "$bold", margin: 0 }}>Timezones</Text>
            <Text
              css={{
                color: "$textSecondary",
                fontSize: "$small",
                margin: 0,
                textAlign: "center",
              }}>
              View and manage multiple timezones in your menu bar
            </Text>
          </Stack>

          {/* ConverterView Screenshot */}
          <Stack align="center" gap="medium">
            <Stack
              css={{
                borderRadius: "$medium",
                overflow: "hidden",
                width: "100%",
              }}>
              <Image
                alt="Timesync ConverterView showing time conversion"
                height={400}
                src="/convert.png"
                style={{
                  height: "auto",
                  width: "100%",
                }}
                width={600}
              />
            </Stack>
            <Text css={{ fontWeight: "$bold", margin: 0 }}>Time Converter</Text>
            <Text
              css={{
                color: "$textSecondary",
                fontSize: "$small",
                margin: 0,
                textAlign: "center",
              }}>
              Convert times using natural language (e.g., "Thursday at 5pm")
            </Text>
          </Stack>

          {/* PreferencesView Screenshot */}
          <Stack align="center" gap="medium">
            <Stack
              css={{
                borderRadius: "$medium",
                overflow: "hidden",
                width: "100%",
              }}>
              <Image
                alt="Timesync PreferencesView showing app settings"
                height={400}
                src="/preferences.png"
                style={{
                  height: "auto",
                  width: "100%",
                }}
                width={600}
              />
            </Stack>
            <Text css={{ fontWeight: "$bold", margin: 0 }}>Preferences</Text>
            <Text
              css={{
                color: "$textSecondary",
                fontSize: "$small",
                margin: 0,
                textAlign: "center",
              }}>
              Customize time format and launch settings
            </Text>
          </Stack>
        </Stack>
      </Stack>
    </Stack>
  );
}

import type { ReactElement } from "react";

const baseUrl = "https://timesync.dolmios.com";

export function StructuredData(): ReactElement {
  return (
    <>
      <script
        dangerouslySetInnerHTML={{
          __html: JSON.stringify({
            "@context": "https://schema.org",
            "@type": "SoftwareApplication",
            applicationCategory: "UtilityApplication",
            author: {
              "@type": "Person",
              name: "Jackson Dolman",
              url: "https://github.com/dolmios",
            },
            codeRepository: "https://github.com/dolmios/timesync",
            description:
              "A macOS menu bar app for managing multiple timezones and converting times. Made for personal use to help schedule meetings across timezones.",
            license: "https://opensource.org/licenses/MIT",
            name: "Timesync",
            operatingSystem: "macOS",
            releaseNotes: "First release - personal project inspired by Hovrly",
            softwareVersion: "0.1.0",
            url: baseUrl,
          }),
        }}
        type="application/ld+json"
      />
      <script
        dangerouslySetInnerHTML={{
          __html: JSON.stringify({
            "@context": "https://schema.org",
            "@type": "Organization",
            description: "macOS menu bar app for timezone management and conversion",
            name: "Timesync",
            url: baseUrl,
          }),
        }}
        type="application/ld+json"
      />
    </>
  );
}

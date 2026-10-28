import { AppContent } from "@/components/app-content";
import { AppHeader } from "@/components/app-header";
import { AppShell } from "@/components/app-shell";

export default function AppHeaderLayout({ children, breadcrumbs }) {
  return (
    <AppShell variant="header">
      <AppHeader breadcrumbs={breadcrumbs} />
      <AppContent variant="header">{children}</AppContent>
    </AppShell>
  );
}

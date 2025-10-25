import { SidebarProvider } from '@/components/ui/sidebar';
import { usePage } from '@inertiajs/react';

export function AppShell({ children, variant = 'header' }) {
    const isOpen = usePage().props.sidebarOpen;

    if (variant === 'header') {
        return (
            <div className="flex min-h-screen w-full flex-col">{children}</div>
        );
    }

    return <SidebarProvider defaultOpen={isOpen}>{children}</SidebarProvider>;
}

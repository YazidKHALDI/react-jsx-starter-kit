import AuthLayoutTemplate from "@/layouts/auth/auth-simple-layout";

export default function AuthLayout({ title = "", description = "", children }) {
  return (
    <AuthLayoutTemplate title={title} description={description}>
      {children}
    </AuthLayoutTemplate>
  );
}

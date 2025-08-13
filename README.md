# Laravel + React JSX Starter Kit  

## 🚀 Introduction  

This is a **JSX-based** version of the Laravel React Starter Kit. It provides a **modern** and **minimalist** setup for building Laravel applications with a React frontend using **[Inertia](https://inertiajs.com)**.  

Unlike the original version, this kit **removes TypeScript** and uses plain JavaScript (`.jsx` instead of `.tsx`), making it easier for developers who prefer **JavaScript over TypeScript**.  

This kit includes **React 19, JavaScript, TailwindCSS 4, and modern UI libraries like [shadcn/ui](https://ui.shadcn.com) and [Radix UI](https://www.radix-ui.com)** to help you build fast and beautiful applications.



## 🎯 Features  

✅ **React 19 + JSX** – No TypeScript, just JavaScript  
✅ **Laravel 12** – Backend power with the latest Laravel features  
✅ **Inertia 2** – Seamless single-page app experience  
✅ **TailwindCSS 4 + ShadCN** – Modern UI components  
✅ **Vite** – Super-fast development with hot module replacement  
✅ **Testing Support** – PHPUnit & Pest included  
✅ **Zero Configuration Required** – Just install and start coding!  

---

## 🛠 Scaffolding Process
### 1️⃣ **Create new React(jsx) project using laravel installer.**  
```bash
laravel new --using=YazidKHALDI/react-jsx-starter-kit react-jsx-app
```

### 2️⃣ **Install Dependencies**  
```bash
cd react-jsx-app
composer install
npm install
```
### 3️⃣ **Setup Environment**  
Copy the `.env.example` file and set up your environment:  
```bash
cp .env.example .env
php artisan key:generate
```

### 4️⃣ **Run Database Migrations**  
```bash
php artisan migrate --seed
```

### 5️⃣ **Start the Development Environment**
```bash
composer dev
```

Your app is now running! 🎉  

---

## 📚 Official Documentation

Documentation for all Laravel starter kits can be found on the [Laravel website](https://laravel.com/docs/starter-kits).

## 🤝 Contributing

Thank you for considering contributing to our starter kit! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## 📜 Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## ⚖️ License

The Laravel + React starter kit is open-sourced software licensed under the MIT license.

---

Happy coding! 🚀

ⵣ
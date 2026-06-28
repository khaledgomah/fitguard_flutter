

export default function Navbar() {
  return (
    <header className="sticky top-0 z-50 flex justify-between items-center w-full px-container-padding py-4 max-w-7xl mx-auto bg-surface border-b border-outline-variant">
      <div className="font-headline-lg text-headline-lg font-bold text-primary">FitGuard</div>
      <div className="flex items-center gap-4">
        <button className="p-2 text-on-surface-variant hover:text-primary transition-colors cursor-pointer">
          <span className="material-symbols-outlined" data-icon="notifications">notifications</span>
        </button>
        <button className="p-2 text-on-surface-variant hover:text-primary transition-colors cursor-pointer">
          <span className="material-symbols-outlined" data-icon="settings">settings</span>
        </button>
        <div className="w-10 h-10 rounded-full bg-surface-variant overflow-hidden border border-outline-variant ml-2">
          <img alt="Abd Elrahman Saeed profile picture" className="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAG3EfTuCHmpMUXeqb8LDfDQ_gkQXWOO_vmna-3MJQUgoVhl30Qk6WyeJCwMWF_a_ruhNdBVduEmqpxOexo3ZjWG78p5UPpGvOISkKtKtpAd7OtuWWqRRROAxkFMSFqU2c1AFGU32bOsdjWrUt2CXF_6QdchpiOTt7psc9HSE2xHo0h7yZitg70YrZ36jsE4JuDMv4wxXElzDtthjdVSS2F_wNPv3EKNJN5Sg81n_3iKKPdcdAfQPQTi0nhVM5ORpKfaBmBVzEcQnn2"/>
        </div>
      </div>
    </header>
  );
}

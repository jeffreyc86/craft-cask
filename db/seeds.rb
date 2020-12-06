#User.destroy_all
#Order.destroy_all
#OrderItem.destroy_all
#Item.destroy_all
#Rating.destroy_all

#creates users
jeff = User.create(first_name: "Jeffrey", username: "alcoholic", password: "snoopdogg", age: 29)
mark = User.create(first_name: "Mark", username: "markymark", password: "abc123", age: 24)
jesus = User.create(first_name: "Jesus", username: "themessiah", password: "biblelover", age: 85)
karen = User.create(first_name: "Karen", username: "callthemanager", password: "walmart", age: 43)
bob = User.create(first_name: "Bob", username: "bobthebuilder", password: "shovel", age: 55)
qtip = User.create(first_name: "Q-Tip", username: "rip_phifedawg", password: "tribecalledquest", age: 29)
cons = User.create(first_name: "Consuela", username: "maslemonpledge", password: "okayiclean", age: 52)
chico = User.create(first_name: "Chico", username: "tacosforlife", password: "tacos4eva", age: 35)
rob = User.create(first_name: "Robert", username: "thegodfather", password: "deniro", age: 68)
don = User.create(first_name: "Donald", username: "trumpsucks", password: "bidenlover", age: 45)
mat = User.create(first_name: "Matilda", username: "chocolatecake22", password: "idom4gic", age: 25)
buzz = User.create(first_name: "Buzz", username: "infinity_beyond", password: "w00dy", age: 37)
jen = User.create(first_name: "Jennifer", username: "imsti11jenny", password: "fromdablock", age: 50)
mary = User.create(first_name: "Mary", username: "ilovedogs", password: "catssuck", age: 62)
nana = User.create(first_name: "Nana", username: "kittenlover", password: "nanana", age: 23)
martha = User.create(first_name: "Martha", username: "b0ssbish", password: "aintnosnitch", age: 29)

#create orders
#checked out orders
16.times do 
    Order.create(user_id: rand(1..16), checked_out: true)
end
#current carts
Order.create(user_id: 1, checked_out: false)
Order.create(user_id: 2, checked_out: false)
Order.create(user_id: 3, checked_out: false)
Order.create(user_id: 4, checked_out: false)
Order.create(user_id: 5, checked_out: false)
Order.create(user_id: 6, checked_out: false)
Order.create(user_id: 7, checked_out: false)
Order.create(user_id: 8, checked_out: false)
Order.create(user_id: 9, checked_out: false)
Order.create(user_id: 10, checked_out: false)
Order.create(user_id: 11, checked_out: false)
Order.create(user_id: 12, checked_out: false)
Order.create(user_id: 13, checked_out: false)
Order.create(user_id: 14, checked_out: false)

#create items
Item.create(name: "Rémy Martin XO Limited Edition Bottle | 750 ml", alcohol_type: "Cognac", price: 169.0, inventory: 0, abv: 40, origin: "France 🇫🇷", description: "Remy Martin XO is a masterful blend of over 400 eaux-de-vie from the two finest-quality vineyards of Cognac and aged up to 30 years in French oak casks. Aromatic, opulent and velvety, with a wide spectrum of stone fruit notes, hints of hazelnut and cinnamon.")
Item.create(name: "Frapin 1270 | 750 ml", alcohol_type: "Cognac", price: 55.0, inventory: 66, abv: 40, origin: "France 🇫🇷", description: "Single estate, 100% Grand Champagne, premier cru de cognac. Exclusively harvested, distilled and aged from the Frapin estate's terroir and know-how. A warm golden straw color. Aromas of vine and lime blossom with a light touch of vanilla from its ageing in Limousin oak barrels.")
Item.create(name: "Ferrand 10 Generations Cognac | 750 ml", alcohol_type: "Cognac", price: 60.0, inventory: 33, abv: 46, origin: "France 🇫🇷", description: "A tribute to the 10 generations of the Ferrand family who have built up their eponymous Cognac house since 1630. This is aged in French oak with 20% in Sauternes casks, and retains a freshness despite its rich character.")
Item.create(name: "Barr Hill Tom Cat Reserve Gin | 750 ml", alcohol_type: "Gin", price: 57.99, inventory: 33, abv: 43, origin: "America 🇺🇸", description: "Barrel aged 4-6 months in new, charred American White Oak, Tom Cat is a completely unique gin with whiskey-like notes of oak, spice and a finish of juniper and raw honey. Tom Cat is the modern day adaption of 18th century England’s most revered spirit, Old Tom gin. After gin was outlawed by the Spirits Act of 1750, rebellious pub owners would hang a wooden plaque shaped like a black cat to inform the passerby of their defiance of the ban. Deposit a few pennies through the cat’s mouth and a bartender would pour a ration of Old Tom to be sipped through a tube between the cat’s paws.")
Item.create(name: "Tod & Vixen’s Dry Gin 1651 | 750 ml", alcohol_type: "Gin", price: 40.0, inventory: 71, abv: 48, origin: "America 🇺🇸", description: "Tod & Vixen’s is made at the Vale Fox Distillery in the Hudson Valley. Botanicals used include juniper, angelica root, red rooibos tea, and Makrut lime. The result is a new-school floral but still dry gin, which makes a damn good martini or any other cocktail you can think of.")
Item.create(name: "Gray Whale Gin | 750 ml", alcohol_type: "Gin", price: 40.0, inventory: 52, abv: 43, origin: "America 🇺🇸", description: "This California gin is made using just six locally sourced botanicals: juniper, kombu, almonds, lime, fir tree, and mint. That simplicity shines through in the flavor of Gray Whale, which is juniper-forward enough for the classicist while stepping just outside the lines of tradition. The brand is also environmentally aware, using biodegradable corks and donating one percent of all sales to an organization that helps protect the oceans.")
Item.create(name: "Fords Gin | 750 ml", alcohol_type: "Gin", price: 24.99, inventory: 43, abv: 45, origin: "England 🏴󠁧󠁢󠁥󠁮󠁧󠁿", description: "Distilled in London at Thames Distillers, Fords Gin is a collaboration between 8th generation Master Distiller, Charles Maxwell, and Simon Ford of The 86 Co. Fords Gin is made up of a thoughtful mix of nine botanicals sourced from around the world. It starts with a traditional base of juniper & coriander seed and is balanced by citrus, florals and spices that are steeped for 15 hours before being distilled. The resulting gin is aromatic, fresh and floral with elegant notes of orange blossom in a harmonious blend with citrus and juniper – each coming together to create the perfect base for any gin-inspired cocktail.")
Item.create(name: "Monkey 47 Distiller’s Cut | 375 ml", alcohol_type: "Gin", price: 80.0, inventory: 28, abv: 47, origin: "Germany 🇩🇪", description: "Monkey 47 is made in the Black Forest of Germany, and 47 botanicals are used in its gin recipe. Each fall, Distiller’s Cut is released, which adds a 48th ingredient to the mix. This bottle is an excellent gin, full of sweet, savory, and floral flavors that deem it a winner.")
Item.create(name: "Roku Gin | 750 ml", alcohol_type: "Gin", price: 29.99, inventory: 70, abv: 43, origin: "Japan 🇯🇵", description: "Suntory has become a household name for their inimitable whiskies but the team of distillers there is ready to prove that their expertise and dedication to craft can extend well beyond the world of whisky. Roku celebrates the Japanese relationship to the four seasons through the prism of unique Japanese botanicals including Sakura flower, Sakura leaf, Sencha tea, Gyokuro tea, Sancho pepper and Yuzu peels.")
Item.create(name: "Xoriguer Gin de Mahón | 1 L", alcohol_type: "Gin", price: 44.96, inventory: 55, abv: 41, origin: "Spain 🇪🇸", description: "One of the few regions on the world with a protected place of origin for gin is found on the tiny unassuming Mediterranean island on Menorca. Gin production began here centuries ago when this was a popular British outpost for the military. Since then, the local production of this one-of-a-kind gin has become a symbol of pride. Made through a direct fire copper pot distillation of local wine, botanical notes of juniper and lemon shine through the glossy surface. The majority of juniper is gathered wild from the neighboring mountains and is definitely the focus of the spirit.")
Item.create(name: "St. George Bruto Americano | 750 ml", alcohol_type: "Liquer", price: 29.99, inventory: 77, abv: 24, origin: "America 🇺🇸", description: "From preeminent American craft distillers St. George comes this gentian based bitter liqueur that delivers new dimesions of flavor and complexity to a very traditional category. It took them a while to get here and having achieved the unthinkable, it is only fair that Lance Winters and team are keeping their propietary recipe to themselves. Instantly one of the best new entries into this category don't waste time mixing this into your bitter and sodas, negronis, spritzes, manhattans and beyond.")
Item.create(name: "Chartreuse | 350 ml", alcohol_type: "Liquer", price: 34.0, inventory: 41, abv: 40, origin: "France 🇫🇷", description: "Looking to add that je ne sais quoi to a cocktail? Think yellow Chartreuse, an herbal liquer. Sweet and mysterious, it adds a ton of incredible flavors and depth to a drink. Keep it simple and pour the syrupy French goodness over ice with sparkling water, et voila: instant cocktail. It’s also delicious in hot chocolate. You know, in case it’s that kind of winter.")
Item.create(name: "Henri Bardouin Pastis | 750 ml", alcohol_type: "Liquer", price: 30.99, inventory: 30, abv: 45, origin: "France 🇫🇷", description: "Initially created to be a substitute for Absente, this Pastis (Anise Liquer) is a thirst-quenching aperitif made from 50 different herbs and spices (21 of which are secret ingredients). Water should be added for best results.")
Item.create(name: "Cointreau | 750 ml", alcohol_type: "Liquer", price: 38.99, inventory: 85, abv: 40, origin: "France 🇫🇷", description: "This full-strength, 80-proof spirit has the versatility to mix with any type of liquor to craft a more elevated cocktail. Distilled from a blend of all-natural sweet and bitter orange peels, Cointreau has a perfectly balanced flavor beloved by mixologists and bartenders worldwide. The superior distillation process maintains the quality of the orange peels and preserves their natural essential oils, lending Cointreau its unique, highly aromatic qualities.")
Item.create(name: "Pavan | 750 ml", alcohol_type: "Liquer", price: 34.99, inventory: 32, abv: 11, origin: "France 🇫🇷", description: "This fragrant liqueur engages you with inviting aromas of peach and apricot nectar wafting from the glass.The sweetness is balanced by the tart and citric acid elements on the palate. Utilize this in your next vodka, gin, bitter or sparkling wine cocktail creation.")
Item.create(name: "Aperol | 750 ml", alcohol_type: "Liquer", price: 24.99, inventory: 82, abv: 11, origin: "Italy 🇮🇹", description: "Aperol is the perfect aperitif, bright orange in color with a deliciously bittersweet orange taste deriving from the infusion of a blend of high-quality herbs and roots. Made in Italy, the original recipe has remained unchanged and a secret to this day.")
Item.create(name: "Patrón XO Cafe | 750 ml", alcohol_type: "Liquer", price: 32.99, inventory: 66, abv: 35, origin: "Mexico 🇲🇽", description: "Patrón XO Cafe is a dry, low-proof coffee liqueur made from combining Patrón Tequila and the essence of fine coffee. It features notes of coffee and light tequila with a smooth, yet dry finish.")
Item.create(name: "Mezcal Unión Uno | 750 ml", alcohol_type: "Mezcal", price: 36.99, inventory: 40, abv: 40, origin: "Mexico 🇲🇽", description: "Artisanally produced and bottled in Oaxaca. Mezcal UNIÓN's goal is to preserve traditional distilling craft and empower locals to grow socioeconomically by uniting artisanal distilleries and agave farmers. A blend of agave Espadín and agave Cirial. Very balanced between the smokiness from the production process and the flavours of the agave.")
Item.create(name: "The Real McCoy 14YO | 750 ml", alcohol_type: "Rum", price: 80.0, inventory: 45, abv: 46, origin: "Barbados 🇧🇧", description: "The Real McCoy plays it straight. This rum comes from Barbados’ Foursquare distillery, where the craft of rum making is taken very seriously. The age statement means something here, as opposed to brands that slap a random number on the bottle, and no sugar or coloring is added. There are wonderful notes of caramel, brown sugar, and toffee on the palate of this fine rum.")
Item.create(name: "Copalli White Rum | 750 ml", alcohol_type: "Rum", price: 29.99, inventory: 81, abv: 42, origin: "Belize 🇧🇿", description: "Made with just three all natural ingredients: Organic Heirloom Sugarcane, Rainforest Canopy Water and Yeast. The double distillation of our sugarcane juice, blend of pot and column still distillation, and the long resting of the finished product on stainless steel creates a smooth white rum that’s as good served straight on the rocks as it is showcased in a daiquiri.")
Item.create(name: "Ten to One Rum Dark Rum | 750 ml", alcohol_type: "Rum", price: 42.0, inventory: 77, abv: 40, origin: "Caribbean 🏴‍☠️", description: "Ten to One is a brand that blends rum from various countries in the Caribbean. In the case of the dark rum, it’s eight-year-old column still rum from Barbados and the Dominican Republic, Trinidadian rum, and some Jamaican pot still rum as well. No color, flavoring, or sugar is added. This is a solid sipper and mixer, not overly sweet with just a hint of that Jamaican rum funk hidden beneath the surface.")
Item.create(name: "Diplomático Rum Reserva Exclusiva | 750 ml", alcohol_type: "Rum", price: 39.99, inventory: 53, abv: 40, origin: "Venezuela 🇻🇪", description: "Diplomatico Rum Reserva Exclusiva is a complex blend of Copper pot still rums aged for 12 long years, has a characterful nose, showing fruit cake, rum'n'raisin ice cream, cocoa, dried ginger, cinnamon and clove. Develops baked bananas with fudge sauce and chewy toffee notes alongside vanilla oak and a deeper note of syrupy gingerbread, with hints of orange zest. The palate evokes chocolate sauce and the sweet toffee, fudge and tropical fruit flavours from the nose.")
Item.create(name: "Cimarron Blanco | 1 L", alcohol_type: "Tequila", price: 25.99, inventory: 74, abv: 40, origin: "Mexico 🇲🇽", description: "Made by none other than tequila legend Enrique Fonseca. The high elevation, complete control over cultivation, proprietary yeasts, and methods of crushing the agave, followed by a long, slow distillation imbues this excellent tequila with layers and layers of bright character. This should be in everybody's well, at everybody's bar, and in everybody's glass. No need to think twice here, folks; this is the real thing. This highland agave tequila is distilled for a dry profile to allow greater control of cocktail sweetness.")
Item.create(name: "Tequila Cabeza | 750 ml", alcohol_type: "Tequila", price: 34.99, inventory: 88, abv: 43, origin: "Mexico 🇲🇽", description: 'This tequila hails from Arandas in Jalisco at the El Ranchito Distillery owned by the Vivanco family, fifth generation agaveros. The agaves are sourced from their own estate which they grow from the "hijuelo" stage (baby shoots) to maturation at 7-9 years of age. The piñas are cooked for 24 hours in 100 degree ovens. Champagne yeast is used for fermentation which occurs only in the winter months. This allows an extended mash period and a fruitier distillate.')
Item.create(name: "Lunazul Blanco Tequila | 750 ml", alcohol_type: "Tequila", price: 24.99, inventory: 60, abv: 40, origin: "Mexico 🇲🇽", description: "Lunazul Tequila is distilled and bottled with 100% Blue Weber Agave at the Tierra de Agaves Distillery in Tequila, Jalisco, Mexico. Tierra de Agaves was founded in 2002 by Francisco Beckmann, former co-owner of Jose Cuervo, to pursue his personal goal of producing the best tequila in the world. Each of the Lunazul varieties, Blanco, Reposado, Añejo and Primero are hand-crafted and rooted in tradition. Lunazul is affordable luxury— 100% agave, hand-labeled and hand- crafted.")
Item.create(name: "El Tesoro Extra Añejo | 750 ml", alcohol_type: "Tequila", price: 100.0, inventory: 32, abv: 40, origin: "Mexico 🇲🇽", description: "Using rare, old stock aged in ex-Bourbon barrels for a minimum of four to five years, this is Extra Añejo that is more than just older for older's sake. As with all aged tequila and especially so for anejos, retaining agave character and balance is paramount. This brand does as masteful a job as any under the guidance of Tequila legend Carlos Camarena.")
Item.create(name: "Hiatus Reposado Tequila | 750 ml", alcohol_type: "Tequila", price: 54.0, inventory: 46, abv: 40, origin: "Mexico 🇲🇽", description: "Hiatus is made at La Cofradia, the same distillery as Casa Noble, which is a good indicator of its quality. Their Reposado is rested 6 months in American whiskey barrels, giving it a pale straw hue. Caramelized agave, roasted red pepper, and cinnamon notes give way to hazelnut and vanilla.")
Item.create(name: "Tears of Llorona Extra Añejo 2019 Batch | 1 L", alcohol_type: "Tequila", price: 250, inventory: 20, abv: 43, origin: "Mexico 🇲🇽", description: "This extra añejo from Tears of Llorona is released in very small batches once a year. It’s a blend of different tequilas aged for five years in different barrel types by master distiller Germán González—Islay scotch, Spanish sherry oak, and Spanish brandy—before being married together. Spend some time with this expensive tequila and enjoy a complex sipping experience with a long finish.")
Item.create(name: "Russian Standard | 750 ml", alcohol_type: "Vodka", price: 21.99, inventory: 55, abv: 40, origin: "Russia 🇷🇺", description: "Recognized in its homeland and around the world as a benchmark for excellence, Russian Standard Original Vodka is unique among vodkas in that it offers both purity AND taste. Made with hardy winter wheat grown on the Black Steppes of Russia and soft glacial waters of Lake Ladoga in Russia's frozen north, the spirit is distilled multiple times, then quadruple filtered through charcoal, and relaxed for 48 hours before bottling. The result is an exceptionally pure, smooth, and delicious vodka. It is a perfect vodka to sip neat or mixed in a cocktail.")
Item.create(name: "Double Cross Vodka | 750 ml", alcohol_type: "Vodka", price: 34.99, inventory: 29, abv: 40, origin: "Slovakia 🇸🇰", description: "Each batch of Double Cross is seven times distilled and filtered, artfully handcrafted by a master distiller using the finest estate-grown winter wheat and Tatra Mountain spring water sourced from 200 foot deep aquifers. The distinctive mineral composition of the spring water, combined with the crisp, clean character of winter wheat results in a bright, yet smooth vodka with a soft, round mouth feel. There is a place where tradition and technology intersect to produce striking new results with a beautiful blend of art and science.")
Item.create(name: "Old Forester 100 Proof | 1 L", alcohol_type: "Whiskey", price: 32.99, inventory: 66, abv: 50, origin: "America 🇺🇸", description: "Arguably, no bourbon in the world packs more punch for the pound than this classic. The concentrated nose is not at all subtle, but instead proudly shows off the robust aromas of vanilla, dried roses, baking spice, and sweet corn. Just as lively on the palate, with a nice kick of rye spice on the finish. Why a full liter? Why 100 proof? Because that's the way we like it.")
Item.create(name: "Four Roses Small Batch | 750 ml", alcohol_type: "Whiskey", price: 37.99, inventory: 53, abv: 45, origin: "America 🇺🇸", description: "Four Roses Small Batch Kentucky Straight Bourbon Whiskey is made from a blend of four different Kentucky bourbons, each distilled at the Four Roses Distillery in Lawrenceburg. The high rye content in two of the bourbons results in a rich, spicy flavor and contributes notes of nutmeg and cinnamon. In addition, the high corn content in the remaining two bourbons results in a lighter, fruitier flavor that balances out the spiciness with notes of maple syrup and caramel.")
Item.create(name: "Wild Turkey 101 | 1 L", alcohol_type: "Whiskey", price: 37.99, inventory: 51, abv: 50, origin: "America 🇺🇸", description: "Wild Turkey 101 is different for good reason, and it all comes down to premium ingredients, select barrels, and a lot of patience. Wild Turkey ages the whiskey longer in new American White Oak barrels with the deepest possible char, cutting no corners across all of our bourbons and giving each one distinctive and rich flavor.")
Item.create(name: "E.H. Taylor Jr. Single Barrel | 750 ml", alcohol_type: "Whiskey", price: 92.95, inventory: 52, abv: 50, origin: "America 🇺🇸", description: "Colonel Edmund Haynes Taylor, Jr. is widely considered one of the founding fathers of the bourbon industry. During his time at Buffalo Trace Distillery, Taylor implemented several innovative methods still used today, including climate-controlled aging warehouses. Each barrel is hand-picked and Bottled in Bond at 100 proof to honor its namesake. The aroma carries lightly toasted oak, with dried figs and butterscotch. One sip brings flavors of sweetness balanced with tobacco and dark spices. The finish is just long enough to prepare the palette for another sip.")
Item.create(name: "Angel's Envy Rye | 750 ml", alcohol_type: "Whiskey", price: 102.40, inventory: 55, abv: 50, origin: "America 🇺🇸", description: "Angel’s Envy Rye Finished in Plantation XO Rum Casks is released just twice each year in the autumn and spring. The rum casks were previously used to age French cognac, which adds an additional layer of complexity on the palate. It’s a collision of bold flavors as the raw, spicy rye mingles with the mellow sweetness of the rum, culminating in a uniquely delicious spirit.")
Item.create(name: "Booker’s Bourbon | 750 ml", alcohol_type: "Whiskey", price: 98.0, inventory: 80, abv: 65, origin: "America 🇺🇸", description: "Booker's Bourbon is part of Jim Beam's Small Batch Collection. Bottled straight from the barrel - uncut and unfiltered. This rare Bourbon is best enjoyed neat with flavours of oak tannin, smoky vanilla, mocha and coffee with a clean and intense finish.")
Item.create(name: "Baker's 7 Year Kentucky Straight Bourbon Whiskey | 750 ml", alcohol_type: "Whiskey", price: 60.99, inventory: 65, abv: 53, origin: "America 🇺🇸", description: "Named after Baker Beam, grand nephew of the legendary Jim Beam, Baker's Bourbon is seven-years-old and hand-bottled at 107 proof. Embracing over six generations of distilling experience, Baker's Bourbon utilizes a special strain of jug yeast that has been in his family for over 60 years. This time tested yeast provides Baker's with a silky smooth texture and consistent taste from batch to batch.")
Item.create(name: "Wild Turkey Master’s Keep Cornerstone Rye | 750 ml", alcohol_type: "Whiskey", price: 175.0, inventory: 42, abv: 54, origin: "America 🇺🇸", description: "It’s hard to beat regular old Wild Turkey; the high quality and low price of the distillery’s bourbon and rye make it an American classic. The distillery has also released several high-end whiskeys over the past few years as part of its Master’s Keep series. The latest is this expensive but excellent rye whiskey aged for 9 to 11 years and bottled at 109 proof. Think of it as a fancier Russell’s Reserve, and enjoy the spice, pepper, and oak notes that pop with every sip.")
Item.create(name: "Michter’s 10 Year Single Barrel Rye | 750 ml", alcohol_type: "Whiskey", price: 160.0, inventory: 48, abv: 46, origin: "America 🇺🇸", description: "Michter’s 10 Year Single Barrel Kentucky Straight Rye continues the legacy of America’s first whiskey variety (rye) from America’s first whiskey company (Michter’s, originally known as Shenk’s). The whiskey is spicy, sweet, and full of toffee and caramel.")
Item.create(name: "Chattanooga Whiskey CASK 111 | 750 ml", alcohol_type: "Whiskey", price: 45.0, inventory: 50, abv: 55, origin: "America 🇺🇸", description: "Handcrafted from a single fermentation in small batches, Chattanooga Whiskey 111 Cask is the unfiltered, barrel strength expression of our signature Tennessee High. By omitting the traditional filtration process, Cask 111 is able to retain every bit of flavor and complexity from the rich ingredients and long maturation process.")
Item.create(name: "Wyoming Whiskey Outryder | 750 ml", alcohol_type: "Whiskey", price: 75.0, inventory: 50, abv: 50, origin: "America 🇺🇸", description: "Wyoming Whiskey Outryder is a unique bottling - not quite rye, but not quite bourbon - combining the foundational soft cornbread, vanilla, caramel, and lemon cake flavors of Wyoming Whiskey Small Batch with a moderately spicy, rich, and robust high-rye whiskey that meld together into a singular experience. Outryder is bottled in bond with flavors of fresh ginger snap in balance with lemon cake, vanilla, and freshly milled grain. A perfect bridge between bourbon and rye and the best of both in a bottle.")
Item.create(name: "Westland Garryana Edition | 750 ml", alcohol_type: "Whiskey", price: 179.99, inventory: 50, abv: 50, origin: "America 🇺🇸", description: "Westland is a Seattle distillery that is doing interesting things in the world of American single malts, like the fourth edition of this whiskey that is all about showcasing the influence of Quercus garryana oak on the spirit. The liquid was matured in a number of other casks as well, including rye, bourbon, and sherry barrels for a range of 44 to 75 months. The result is a particularly fruity single malt that should appeal to those who are interested in the burgeoning American single malt category.")
Item.create(name: "Teeling Single Cask | 750 ml", alcohol_type: "Whiskey", price: 100.0, inventory: 50, abv: 55, origin: "America 🇺🇸", description: "The Teeling distillery was the first to open within the Dublin city limits in over a century, back in 2015. The core lineup consists of expertly sourced whiskeys from the Cooley distillery, but whiskey production is going on at the Dublin facility itself. This Single Cask expression (a U.S.-only release) is finished in chestnut casks for an additional period of time after maturation, and it has an earthy funk reminiscent of apple or pear brandy, along with a sweet caramel undertone to balance it out. Less than 850 bottles are available in New York, California, and Illinois.")
Item.create(name: "The Tyrconnell 16 Year Old Oloroso & Moscatel Cask Finish | 750 ml", alcohol_type: "Whiskey", price: 100.0, inventory: 50, abv: 46, origin: "Ireland 🇮🇪", description: "Tyrconnell 16 Year Oloroso & Moscatel Cask Finish is a single malt release which spends its first 16 years maturing in American oak ex-bourbon barrels. Then the whiskey ages for a time in wine casks from the Andalusian region which initially were seasoned with oloroso sherry before a second seasoning of moscatel wine.")
Item.create(name: "Egan’s Centenary | 750 ml", alcohol_type: "Whiskey", price: 100.0, inventory: 50, abv: 46, origin: "Ireland 🇮🇪", description: "Egan’s Centenary is a blend of malt and grain whiskeys that were finished in XO cognac casks. It was released in commemoration of a century passing since co-founder Henry Egan’s death, with less than 6,000 bottles made available. The history of the brand dates back to the 1800s, but it was revived in 2013 using sourced whiskey from an undisclosed distillery. This new whiskey is bright and bold, with malty notes that wrap around a zing of spice as you sip.")
Item.create(name: "Hatozaki Blended | 750 ml", alcohol_type: "Whiskey", price: 34.0, inventory: 50, abv: 40, origin: "Japan 🇯🇵", description: "Named after the oldest stone lighthouse in Japan, Hatozaki blended whisky is made at Kaikyo distillery. Matured in a variety of casks, including sherry, bourbon and Mizunara oak it has a complex character, with notes of cherry blossom, pears and caramel throughout the palate.")
Item.create(name: "Nikka Coffee Grain | 750 ml", alcohol_type: "Whiskey", price: 63.0, inventory: 50, abv: 45, origin: "Japan 🇯🇵", description: "A release of grain whisky from Japan's Nikka, produced mainly from corn using one of their continuous Coffey stills. Rather than the rare and limited releases they have done before, this is a larger release to further show off this key component in the Nikka family of whiskies.")
Item.create(name: "Hakushu 12 Year Old | 750 ml", alcohol_type: "Whiskey", price: 200.0, inventory: 50, abv: 43, origin: "Japan 🇯🇵", description: "Distilled in the guise of a Scotland-based distillery, this Japanese handcrafted drink leaves little to be desired. As soon as you uncork a bottle of this masterpiece, you've unleashed an amalgam of toasted barley, almonds and even a bit of char. That said, the crisp taste hits your lips with a grassy, herby, smoky blend that's nothing short of phenomenal. The aging process makes these flavors even more pronounced. If you've never tried a Japanese whisky, you should probably start here.")
Item.create(name: "Ohishi Single Sherry Cask | 750 ml", alcohol_type: "Whiskey", price: 84.99, inventory: 50, abv: 42, origin: "Japan 🇯🇵", description: "Ohishi is a hidden Japanese gem nestled in the mountainous countryside, along with the banks of the Kuma River, one of Japan’s fastest flowing rivers, also known for its pristine water quality. The family-run operation was established in 1872. This Ohishi Sherry Cask is a blend of casks anywhere from143.0 3 to 25 years old. Exp3ct notes of dried tropical fruit, toasted hazelnut, golden raisins, and sweet marzipan.")
Item.create(name: "Yamazaki 12 Year Old | 750 ml", alcohol_type: "Whiskey", price: 143.0, inventory: 50, abv: 43, origin: "Japan 🇯🇵", description: "One of the first Japanese single malts to break into the UK market, Suntory's Yamazaki 12 Year Old continues to impress with its well-balanced fruity sweetness, something that appeals to novice and experienced whisky drinkers alike. Medium bodied and honeyed in style, this easy vanilla malt bursts with apple fruit and jasmine freshness but is made complex thanks to notes of candied orange peel, cinnamon and clove spice and balancing dusty cigarette ash and cedarwood dryness.")
Item.create(name: "Nikka Days | 750 ml", alcohol_type: "Whiskey", price: 40.0, inventory: 50, abv: 40, origin: "Japan 🇯🇵", description: "A vibrant addition to the Nikka range, Nikka Days is a bright and vivacious blend of malt and grain whiskies from both Nikka's Yoichi and Miyagikyo distilleries. Its medium body hosts an array of floral and zesty flavours which mingle effortlessly with an underlying vanilla-toffee depth and a light, distant touch of breezy peat smoke. A fresh and delicate whisky, Days makes a delicious sipping dram or sits beautifully in a refreshing highball.")
Item.create(name: "Akashi Single Malt | 750 ml", alcohol_type: "Whiskey", price: 133.0, inventory: 50, abv: 46, origin: "Japan 🇯🇵", description: "Ten months out of each year, the White Oak Distillery produces Sake and Shochu exclusively. So all of their Whisky production happens in just two months. Eigashima’s most popular Whisky is their Akashi Blend. But they also produce a few precious runs of their Akashi Single Malt — which is then divided up between their finished-woods and Whisky blends. That means that there is jut not a lot of this dram to go around. Technically, it’s a marriage of their Single Malt in three different agings — seven, five, and four year-old — from three different cask types — Spanish Sherry, New American Oak, and ex-Bourbon.")
Item.create(name: "Chichibu Ichiro's Malt and Grain | 750 ml", alcohol_type: "Whiskey", price: 101.99, inventory: 50, abv: 46, origin: "Japan 🇯🇵", description: "Ichiro's Malt & Grain is labeled as a 'worldwide blended whisky'. The exact components of this gem are kept secret, but there appears to be a lot of local, Japanese spirit with enough outside elements to craft the flavor profile Ichiro was looking for. It is — obviously — a combination of Single Malts and grain Whiskies married at the Chichibu Distillery, but all that you will notice is the lovely flavor profile, delicate texture, and spot-on 46% ABV.")
Item.create(name: "Monkey Shoulder | 750 ml", alcohol_type: "Whiskey", price: 35.49, inventory: 50, abv: 40, origin: "Scotland 🏴󠁧󠁢󠁳󠁣󠁴󠁿", description: "Monkey Shoulder is a blend of Speyside single malt Scotch whiskies which are married together for flavor and consistency. The richness and vibrancy combine with fruity aromas and mellow vanilla, making it perfect for mixed drinks and cocktails.")
Item.create(name: "Laphroaig 10 Year Cask Strength | 750 ml", alcohol_type: "Whiskey", price: 68.0, inventory: 50, abv: 43, origin: "Scotland 🏴󠁧󠁢󠁳󠁣󠁴󠁿", description: "It's no secret that Scotland is renowned for its whiskies. Iodine-rich scotch from the Islay region is among the country's most characterful drams, with Laphroaig offering one of the most exceptional medicinal malts. The Laphroaig 10 Year is the company's entry-level scotch, which boasts a medium caramel color when poured into a glass. Scents of smoke, decay, salt, charcoal, leather and wet stone hit the nose, opening up to herbal ocean tones, peanut butter fudge and a sweet gumminess.")
Item.create(name: "The GlenDronach Cask Strength Batch 8 | 750 ml", alcohol_type: "Whiskey", price: 95.0, inventory: 50, abv: 61, origin: "Scotland 🏴󠁧󠁢󠁳󠁣󠁴󠁿", description: "Fans of sherry cask single malts like The Macallan and Aberlour should definitely try this new, cask strength version of The GlenDronach. It spent 10 years in PX and Oloroso sherry casks before being bottled at 122 proof, which provides some nice heat and spice to the sweet notes of dried fruit and fig. This is the eighth batch of the cask strength expression, which is non-chill filtered with no color added.")
Item.create(name: "Highland Park Twisted Tattoo | 750 ml", alcohol_type: "Whiskey", price: 100.0, inventory: 50, abv: 47, origin: "Scotland 🏴󠁧󠁢󠁳󠁣󠁴󠁿", description: "The Highland Park Twisted Tattoo a marriage of two different 16-year-old whiskies aged in Spanish Rioja-seasoned casks and bourbon barrels. There are ripe berry notes, just a hint of peat, and delicious vanilla and caramel flavors bubbling up every now and then. The influence of the Rioja casks is strong here, and that’s a good thing.")

#creat at orderitems
50.times do
OrderItem.create(order_id: rand(1..16), item_id: rand(1..57))
end

40.times do
OrderItem.create(order_id: rand(17..30), item_id: rand(1..57))
end

#create reviews
3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 5, review: "Loved this! Is great neat or on the rocks.")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 5, review: "Went perfectly with the cocktails I was making")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 5, review: "This shit slapppssssss")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 5, review: "Just WOW!!!! Definite buy")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 5, review: "Such a nice finish!")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 5, review: "Couldn't stop drinking. Might b drunkkkkkkskfdgt43efsd")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 5, review: "Purchasing the remaining stock right now!")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 5, review: "So delicious! Transported me right back to pre-COVID")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 4, review: "Tasted great, but would've been better if we could've drank it outside in a bar...without masks")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 4, review: "Pretty good")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 4, review: "Reminded me of a drink I had back in Rome. Quite tasty")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 4, review: "OMG so yumm!")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 4, review: "Almost perfect. Wish it went down a bit smoother.")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 4, review: "Loved the design on the bottle. Taste was pretty good.")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 3, review: "Not my fav but still a good drink")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 3, review: "Ehhh I've had better")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 3, review: "My partner got mad because I purchased the wrong version. Had to sleep on the couch")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 3, review: "Got pretty hammered, but woke up with the worst hangover")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 2, review: "Steer clear! Gave me the worst hangover")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 2, review: "Not the best...")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 2, review: "Taste is def not worth the price")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 2, review: "Couldn't get it down but my friend loved it")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 1, review: "Not a fan")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 1, review: "I'd barely call this drinkable")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 1, review: "Never buying again")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 1, review: "Love most of the spirits on here but this one was a bummer")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 0, review: "THE WORST!!!!")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 0, review: "Hated this")
end

3.times do
Review.create(user_id: rand(1..16), item_id: rand(1..57), rating: 0, review: "Wish I could get my money back. This definitely was not worth it")
end

puts "Data has been seeded!"
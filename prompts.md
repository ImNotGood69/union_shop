prompt for search bar (not sure why the AI automatically started implementing)

Generate me a prompt to give to an LLM that will add a usable search bar to search and look up items, please analyse the entire codebase to make it responsive . and so that when the names of items in the website change. (or if i add more items to this shop) the search bar will still show those items.

prompt for footer

please give me a footer that displays opening hours (make these just monday to friday 9am to 5pm) and a contact us page that uses the email: fakeemail@email.com
and a phone number that is :
076942099019

prompt for collections and carousel 

in the area where the large image with the button is. please turn it into a carousel, please add the button on the next slide that says "view collections", subsequently, create a page that would show collections of certain themes. these themes being autumn favourites, black friday. these clickable widgets should also include image tags. which i will populate later

prompt for arrows on carousel:

please add arrow shaped buttons to the left and right of the carousel so that you can click and go to the other part of the carousel

product page prompt to start off design,

in my app, i want to have widgets that would mimic a real store, please implement the image of the product. (currently whatever the product is, this will be changed later). i need to the left of the images a way to select different sizes (s, m, l, xl,) and a quanitity list, aswell as a rectangular purchase button, which doesnt have to work. please maintin the theme of the current website. ensuring that the look is modern.


n the black friday collection, change the names of the products to include: portsmouth university 2025 hoodie, and neutral classic sweatshirt. , please populate that in the current placeholders of that, i want you also to direct me on to how to change the price, as now i want two values to be present, the discounted price , and the original price (original price should have a line through,)



screen overflow error, prompt to help with it

write me a prompt to give to an LLM
i want the AI to analyze my entire codebase and give fix the current screen overflow error found in the black friday page, i want the tiles. (where the products are displayed) to have the same layout as the products section with the tiles. analyze my whole repo and make the necessary changes to fix this bug

prompt AI gave back:

Prompt:

Analyze my entire Flutter codebase and fix a screen overflow error on the Black Friday collection page.

Current Issue:

The Black Friday page (collection detail page) has a screen overflow error
The product tiles on the collection detail page should match the exact layout and styling of the product tiles found in the main products section (home page)
Requirements:

Scan the entire repository to understand the current implementation
Identify the layout/styling used for product tiles in the main products section (main.dart)
Compare it with the product tiles in the collection detail page (collection_detail.dart)
Fix the overflow error by adjusting the grid sizing/constraints
Update the collection detail product tiles to use the exact same layout pattern as the main products section tiles (image size, spacing, card structure, text styling, price display)
Ensure the layout is responsive and doesn't overflow on different screen sizes
Make all necessary code changes to implement this fix
Key Files to Check:

main.dart - contains the main products section with the reference tile layout
collection_detail.dart - the page with the overflow error that needs fixing
product.dart - product data model
lib/widgets/* - any shared widget components
Please analyze the codebase, identify the root cause of the overflow, and implement a complete fix that makes the collection tiles match the main product tiles exactly.


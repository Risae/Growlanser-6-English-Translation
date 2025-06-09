Source: https://github.com/NationalSecurityAgency/ghidra/discussions/3853

    Nvm I figured it out so to mark the whole thing as answer in case someone wants to know:

        1. In the source program, right click, export and select XML. In Options, select everything BUT "Memory Content", this will export everything except the actual memory such that it won't be recoverable after this.

        2. You can freely share this XML file now.

        3. The person receiving it has to first open the ACTUAL binary like they would normally to make use of the XML (they can't import it on its own because it will have the markup, but no content to back it).

        4. Once imported DO NOT ANALYSE YET (since the XML is already from an analysed state) and do File -> Add to program then select the xml file. Leave everything default (it should detect XML input format) and click ok.

        5. You now have a program with the content AND the markup of the original without actually sharing the content.

    As said though, this is lossy: it was unable to for example recover some instruction flow override I did, but MOST of the information is there (data types, functions, symbols, XREFS, etc...).
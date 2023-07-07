const hre = require("hardhat");

// npx hardhat verify --network testnet_evm 0xa7bbb031936f0e28b7a9fa380723d25d4cabb2df
async function main() {
    console.log(`>> ✅ Verifying contract on Etherscan...`);
    try {
        await hre.run(`verify:verify`, {
            address: '0x5FbDB2315678afecb367f032d93F642f64180aa3',
            // constructorArguments: [addresses.WCFX],
        });
    } catch (error) {}
    console.log(`>> ✅ Done for AddressMetadata`);
}

main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});

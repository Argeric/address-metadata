const hre = require("hardhat");
const AddressMetadataJSON = require('../artifacts/contracts/AddressMetadata.sol/AddressMetadata.json')

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log(">> ✅ deployer:", deployer.address);
    console.log(">> ✅ balance:", (await deployer.getBalance()).toString());

    // const AddressMetadata = new hre.ethers.ContractFactory(AddressMetadataJSON.abi, AddressMetadataJSON.bytecode, deployer);
    const AddressMetadata = await hre.ethers.getContractFactory("AddressMetadata", deployer);
    // console.log(`0_deploy AddressMetadata`, AddressMetadata);
    const addressMetadata = await AddressMetadata.deploy();
    // console.log(`1_deploy addressMetadata`, addressMetadata);
    await addressMetadata.deployed();
    console.log(">> ✅ AddressMetadata deploy at:", addressMetadata.address);

    const nameTags = await addressMetadata.listNameTags(0, 10);
    console.log(">> ✅ nameTags:", nameTags);
}

main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});
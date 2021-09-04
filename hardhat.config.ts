import { HardhatUserConfig } from "hardhat/types";
import "@nomiclabs/hardhat-waffle";
import "hardhat-typechain";
// id for infura project
const INFURA_PROJECT_ID = "TODO";
// random metamask wallet (never use it on mainnet or upload to github)
const ROPSTEN_PRIVATE_KEY = "TODO";
const config: HardhatUserConfig = {
  solidity: "0.7.3",
  networks: {
    ropsten: {
      url: `https://ropsten.infura.io/v3/${INFURA_PROJECT_ID}`,
      accounts: [`0x${ROPSTEN_PRIVATE_KEY}`]
    }
  }
};
export default config;

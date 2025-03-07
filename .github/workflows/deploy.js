async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  const Claim = await ethers.getContractFactory('Claim');
  const claim = await Claim.deploy();

  console.log('Claim contract deployed to:', claim.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

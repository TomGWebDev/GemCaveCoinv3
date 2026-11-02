# GemCaveCoinv3

Solidity contracts for the GemCave token, staking system, and GemCave Dig NFT collection. The NFT design generates gem traits and renders SVG artwork and metadata on-chain.

## Folder contents

- [`contracts/`](contracts/) — project-owned token, staking, NFT, builder, and rendering contracts, plus bundled third-party dependencies. See [`contracts/README.md`](contracts/README.md) for the project-source file inventory.
- [`README.md`](README.md) — project overview and notes.

## What is included

- `contracts/GemCaveToken.sol` — GemCave ERC-20 token contract, including transfer rules and mint-payment integration.
- `contracts/GemCaveStake.sol` — three-product token staking contract with configurable lock periods and rewards.
- `contracts/GemCaveStake2.sol` — four-product staking contract variant.
- `contracts/GemCaveDig.sol` — ERC-721 collection contract that charges tokens to mint gems and stores token traits and metadata.
- `contracts/GemCaveBuilder.sol` — gem trait and render-code generation.
- `contracts/GemCaveRender.sol` and `contracts/GemCaveRenderShape*.sol` — on-chain SVG rendering and shape-specific drawing.

The gem builder assigns a type, cut, condition, and carat weight. The renderer uses the generated render code to create SVG artwork. NFT JSON metadata and the image are encoded as data URIs, so the collection is designed not to depend on IPFS for token artwork or metadata.

## Source status

This repository contains contract source files only. It does not currently include a Solidity compiler configuration, dependency manifest, automated tests, deployment scripts, or a deployment guide.

The checked-in source has deployment placeholders. For example, `GemCaveDig.sol` initializes its builder, renderer, and token contract addresses to `address(0)`, and the token source has zero-address integration placeholders. These contracts need project-specific configuration and review before they can work together in a deployment.

## Solidity version

The project contracts declare `pragma solidity ^0.8.4`. Compile them with a compatible Solidity 0.8.x compiler after configuring the intended dependencies and deployment addresses.

## Important considerations

- `GemCaveBuilder.sol` derives gem attributes from block and transaction data. This is not secure randomness and should not be treated as unpredictable for high-value outcomes.
- Staking and token contracts manage user funds. Review their behavior, configuration, and integration addresses carefully before deployment or use.
- Several files include copied or adapted OpenZeppelin-style contracts. Refer to the notices in the source files for attribution and applicable licensing terms.

## License

The project contracts declare `UNLICENSED`. No project-wide license has been provided in this source snapshot. Review the individual source headers and third-party notices before reuse or redistribution.

pragma solidity ^0.4.18;

import './WNS.sol';

/**
 * A registrar that allocates subdomains to the first person to claim them, but
 * expires registrations a fixed period after they're initially claimed.
 */
contract TestRegistrar {
    uint constant registrationPeriod = 4 weeks;

    WNS public wns;
    bytes32 public rootNode;
    mapping (bytes32 => uint) public expiryTimes;

    /**
     * Constructor.
     * @param wnsAddr The address of the WNS registry.
     * @param node The node that this registrar administers.
     */
    function TestRegistrar(WNS wnsAddr, bytes32 node) public {
        wns = wnsAddr;
        rootNode = node;
    }

    /**
     * Register a name that's not currently registered
     * @param subnode The hash of the label to register.
     * @param owner The address of the new owner.
     */
    function register(bytes32 subnode, address owner) public {
        require(expiryTimes[subnode] < now);

        expiryTimes[subnode] = now + registrationPeriod;
        wns.setSubnodeOwner(rootNode, subnode, owner);
    }
}

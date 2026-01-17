// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// 完整的Post合约 - 解决抽象合约问题
contract Post {
    // 帖子结构体
    struct PostData {
        uint256 id;
        address author;
        string text;
        uint256 timestamp;
        uint256 likes;
        uint256 repliesCount;
        uint256 repostsCount;
    }
    
    // 奖励设置（1个BAIT）
    uint256 public constant BAIT_REWARD = 1 * 10**18;
    uint256 public constant MAX_TEXT_LENGTH = 280;
    
    // 帖子数组
    PostData[] public posts;
    
    // 回复映射：postId => 回复帖子ID数组
    mapping(uint256 => uint256[]) public replies;
    
    // 转发映射：postId => 转发者地址数组
    mapping(uint256 => address[]) public reposters;
    
    // 点赞映射：地址 => postId => 是否点赞
    mapping(address => mapping(uint256 => bool)) public liked;
    
    // 事件
    event NewPost(uint256 indexed id, address indexed author, string text);
    event PostLiked(uint256 indexed id, address indexed liker);
    event PostReplied(uint256 indexed id, uint256 indexed replyId);
    event PostReposted(uint256 indexed id, address indexed reposter);
    
    // BAIT代币合约接口
    address public baitToken;
    
    // Identity合约接口
    address public identityContract;
    
    // 构造函数 - 确保正确初始化
    constructor(address _baitToken, address _identityContract) {
        require(_baitToken != address(0), "Invalid bait token");
        require(_identityContract != address(0), "Invalid identity contract");
        
        baitToken = _baitToken;
        identityContract = _identityContract;
        
        // 添加空帖子（ID从1开始）
        posts.push(PostData({
            id: 0,
            author: address(0),
            text: "",
            timestamp: 0,
            likes: 0,
            repliesCount: 0,
            repostsCount: 0
        }));
    }
    
    // 创建帖子
    function createPost(string memory _text) external {
        require(bytes(_text).length > 0, "Empty text");
        require(bytes(_text).length <= MAX_TEXT_LENGTH, "Text too long");
        
        uint256 newId = posts.length;
        posts.push(PostData({
            id: newId,
            author: msg.sender,
            text: _text,
            timestamp: block.timestamp,
            likes: 0,
            repliesCount: 0,
            repostsCount: 0
        }));
        
        // 奖励用户1个BAIT
        _mintBAIT(msg.sender, BAIT_REWARD);
        
        emit NewPost(newId, msg.sender, _text);
    }
    
    // 回复帖子
    function replyToPost(uint256 _postId, string memory _text) external {
        require(_postId > 0 && _postId < posts.length, "Invalid post");
        require(bytes(_text).length > 0, "Empty text");
        require(bytes(_text).length <= MAX_TEXT_LENGTH, "Text too long");
        
        uint256 replyId = posts.length;
        posts.push(PostData({
            id: replyId,
            author: msg.sender,
            text: _text,
            timestamp: block.timestamp,
            likes: 0,
            repliesCount: 0,
            repostsCount: 0
        }));
        
        // 添加到回复映射
        replies[_postId].push(replyId);
        posts[_postId].repliesCount++;
        
        // 奖励用户1个BAIT
        _mintBAIT(msg.sender, BAIT_REWARD);
        
        emit PostReplied(_postId, replyId);
        emit NewPost(replyId, msg.sender, _text);
    }
    
    // 转发帖子
    function repost(uint256 _postId) external {
        require(_postId > 0 && _postId < posts.length, "Invalid post");
        require(!hasReposted(_postId, msg.sender), "Already reposted");
        
        reposters[_postId].push(msg.sender);
        posts[_postId].repostsCount++;
        
        // 奖励用户1个BAIT
        _mintBAIT(msg.sender, BAIT_REWARD);
        
        emit PostReposted(_postId, msg.sender);
    }
    
    // 点赞帖子
    function likePost(uint256 _postId) external {
        require(_postId > 0 && _postId < posts.length, "Invalid post");
        require(!liked[msg.sender][_postId], "Already liked");
        
        liked[msg.sender][_postId] = true;
        posts[_postId].likes++;
        
        emit PostLiked(_postId, msg.sender);
    }
    
    // 检查是否已转发
    function hasReposted(uint256 _postId, address _user) public view returns (bool) {
        for (uint i = 0; i < reposters[_postId].length; i++) {
            if (reposters[_postId][i] == _user) {
                return true;
            }
        }
        return false;
    }
    
    // 获取帖子详情
    function getPost(uint256 _postId) public view returns (
        uint256 id,
        address author,
        string memory text,
        uint256 timestamp,
        uint256 likes,
        uint256 repliesCount,
        uint256 repostsCount
    ) {
        require(_postId > 0 && _postId < posts.length, "Invalid post");
        PostData memory post = posts[_postId];
        
        return (
            post.id,
            post.author,
            post.text,
            post.timestamp,
            post.likes,
            post.repliesCount,
            post.repostsCount
        );
    }
    
    // 获取帖子回复
    function getReplies(uint256 _postId) public view returns (uint256[] memory) {
        return replies[_postId];
    }
    
    // 获取转发者
    function getReposters(uint256 _postId) public view returns (address[] memory) {
        return reposters[_postId];
    }
    
    // 获取帖子总数
    function getPostCount() public view returns (uint256) {
        return posts.length - 1;
    }
    
    // 获取最新帖子（简化版本）
    function getLatestPosts(uint256 _count) public view returns (
        uint256[] memory ids,
        address[] memory authors,
        string[] memory texts,
        uint256[] memory timestamps,
        uint256[] memory likesCount,
        uint256[] memory repliesCounts,
        uint256[] memory repostsCounts
    ) {
        uint256 totalPosts = posts.length - 1;
        uint256 count = _count > totalPosts ? totalPosts : _count;
        
        ids = new uint256[](count);
        authors = new address[](count);
        texts = new string[](count);
        timestamps = new uint256[](count);
        likesCount = new uint256[](count);
        repliesCounts = new uint256[](count);
        repostsCounts = new uint256[](count);
        
        for (uint256 i = 0; i < count; i++) {
            uint256 index = posts.length - i - 1;
            PostData storage post = posts[index];
            
            ids[i] = post.id;
            authors[i] = post.author;
            texts[i] = post.text;
            timestamps[i] = post.timestamp;
            likesCount[i] = post.likes;
            repliesCounts[i] = post.repliesCount;
            repostsCounts[i] = post.repostsCount;
        }
        
        return (ids, authors, texts, timestamps, likesCount, repliesCounts, repostsCounts);
    }
    
    // 获取帖子基本信息（简化版本）
    function getPostBasic(uint256 _postId) public view returns (
        address author,
        string memory text,
        uint256 timestamp,
        uint256 likesCount,
        uint256 repliesCount,
        uint256 repostsCount
    ) {
        require(_postId > 0 && _postId < posts.length, "Invalid post");
        PostData storage post = posts[_postId];
        
        return (
            post.author,
            post.text,
            post.timestamp,
            post.likes,
            post.repliesCount,
            post.repostsCount
        );
    }
    
    // 内部函数：调用BAIT合约的mint函数
    function _mintBAIT(address to, uint256 amount) private {
        // 简单的BAIT合约接口
        (bool success, ) = baitToken.call(
            abi.encodeWithSignature("mint(address,uint256)", to, amount)
        );
        require(success, "BAIT mint failed");
    }
    
    // 获取用户是否点赞了某个帖子
    function getUserLikeStatus(uint256 _postId, address _user) public view returns (bool) {
        return liked[_user][_postId];
    }
}
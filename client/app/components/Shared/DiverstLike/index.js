import React, {useState} from 'react';
import { compose } from 'redux';
import { withStyles, withTheme } from '@material-ui/core/styles';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Label = styled.label`
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
`;

const Span = styled.span`
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: grey;
  border-radius: 34px;
  &:before{
    position: absolute;
    content: '';
    height: 26px;
    width: 26px;
    left: 4px;
    bottom: 4px;
    background: white;
    border-radius: 50%;
  }
`;

const Input = styled.input`
  &:checked + ${Span} {
    background: blue;
  }

  &:checked + ${Span}:before {
    -webkit-transform: translateX(26px);
    -ms-transform: translateX(26px);
    transform: translateX(26px);  }
`;

const Count = styled.label`
  align-content: center
`;
export function DiverstLike(props) {
  const { isLiked: defaultLiked, totalLikes: defaultCount } = props;

  const [liked, setLiked] = useState(defaultLiked);
  const [count, setCount] = useState(defaultCount);

  function like() {
    setLiked(true);
    setCount(defaultLiked ? defaultCount : defaultCount + 1);
  }
  function unlike() {
    setLiked(false);
    setCount(defaultLiked ? defaultCount - 1 : defaultCount);
  }

  return (
    <React.Fragment>
      <Label>
        <Input checked={liked}
          type='checkbox'
          onChange={() => {
            if (liked)
              props.unlikeNewsItemBegin({ news_feed_link_id: props.newsFeedLinkId, callback: unlike });
            else
              props.likeNewsItemBegin({ news_feed_link_id: props.newsFeedLinkId, callback: like });
          }}
        />
        <Span />
      </Label>
      <Count>{count}</Count>
    </React.Fragment>
  );
}

DiverstLike.propTypes = {
  totalLikes: PropTypes.number,
  isLiked: PropTypes.bool,
  newsFeedLinkId: PropTypes.number,
  answerId: PropTypes.number,
  likeNewsItemBegin: PropTypes.func,
  unlikeNewsItemBegin: PropTypes.func,
};

export default compose(
  withTheme,
)(DiverstLike);

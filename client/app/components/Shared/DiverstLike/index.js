import React from 'react';
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
  const { isLiked } = props.isLiked;
  return (
    <React.Fragment>
      <Label>
        <Input checked={isLiked}
          type='checkbox'
          onChange={() => {
            if (isLiked)
              props.likeNewsItemBegin(props);
            else
              props.unlikeNewsItemBegin(props);
          }}
        />
        <Span />
      </Label>
      <Count>{props.totalLikes}</Count>
    </React.Fragment>
  );

/*  return (
    <React.Fragment>
      <Label/>
    </React.Fragment>
  );
*/
}

DiverstLike.propTypes = {
//  likes: PropTypes.object,
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

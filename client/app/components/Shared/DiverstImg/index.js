import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

// This component is intended for rendering images from a base64 string,
// likely image data encoded in base64 received from a serializer.
export function DiverstImg(props) {
  const { classes, data, maxWidth, maxHeight, minWidth, minHeight, alt, styles, imgProps, ...rest } = props;

  return (
    <React.Fragment>
      {data && (
        <img
          src={`data:image/jpeg;base64,${data}`}
          alt={alt}
          style={{
            maxWidth,
            maxHeight,
            minWidth,
            minHeight,
            ...styles,
          }}
        />
      )}
    </React.Fragment>
  );
}

DiverstImg.propTypes = {
  classes: PropTypes.object,
  data: PropTypes.string.isRequired,
  maxWidth: PropTypes.string,
  maxHeight: PropTypes.string,
  minWidth: PropTypes.string,
  minHeight: PropTypes.string,
  alt: PropTypes.string,
  styles: PropTypes.object,
  imgProps: PropTypes.object,
};

DiverstImg.defaultProps = {
  maxWidth: '350px',
  maxHeight: '350px',
};

export default compose(
  memo,
)(DiverstImg);

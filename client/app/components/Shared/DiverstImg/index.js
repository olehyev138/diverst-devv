import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

// This component is intended for rendering images from a base64 string,
// likely image data encoded in base64 received from a serializer.
export function DiverstImg(props) {
  const { classes, data, maxWidth, maxHeight, alt, styles, imgProps, ...rest } = props;

  return (
    <React.Fragment>
      {data && (
        <img
          src={`data:image/jpeg;base64,${data}`}
          alt={alt}
          style={{
            maxWidth: `${maxWidth}px`,
            maxHeight: `${maxHeight}px`,
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
  maxWidth: PropTypes.number,
  maxHeight: PropTypes.number,
  alt: PropTypes.string,
  styles: PropTypes.object,
  imgProps: PropTypes.object,
};

DiverstImg.defaultProps = {
  maxWidth: 350,
  maxHeight: 350,
};

export default compose(
  memo,
)(DiverstImg);
